// lib/home/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/user_service.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import 'privacy_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final data = await UserService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['firstName'] ?? '';
    final lastName = _userData?['lastName'] ?? '';
    final email =
        _userData?['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
    final fullName = '$firstName $lastName'.trim();
    final initials = UserService.getInitials(firstName, lastName);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(l, fullName, email, initials),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoCard(l),
                  const SizedBox(height: 16),
                  _buildMenuSection(context, l),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(S l, String fullName, String email, String initials) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _loading
              ? CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.inputBorder(context),
                )
              : CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    initials.isNotEmpty ? initials : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          const SizedBox(height: 12),
          _loading
              ? SizedBox(
                  width: 120,
                  height: 20,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.inputBorder(context),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Text(
                  fullName.isNotEmpty ? fullName : 'User',
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary),
            ),
            child: Text(
              l.homeUser,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(S l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('3', l.projects),
          _buildDivider(),
          _buildStat('12', l.favorites),
          _buildDivider(),
          _buildStat('2', l.rooms),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.inputBorder(context),
    );
  }

  Widget _buildMenuSection(BuildContext context, S l) {
    final items = [
      {'icon': Icons.person_outline, 'label': l.editProfile},
      {'icon': Icons.notifications_none, 'label': l.notifications},
      {'icon': Icons.lock_outline, 'label': l.privacy},
      {'icon': Icons.help_outline, 'label': l.helpSupport},
    ];

    return Column(
      children: [
        ...items.map((item) {
          final label = item['label'] as String;
          final icon = item['icon'] as IconData;
          return _buildMenuItem(
            icon: icon,
            label: label,
            onTap: label == l.editProfile
                ? () => _showEditProfileSheet(context)
                : label == l.privacy
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  )
                : () {},
          );
        }),

        // 🌍 IDIOMA
        _buildLanguageSelector(l),

        // 🌙 TEMA
        _buildMenuItem(
          icon: themeProvider.isDark ? Icons.nightlight_round : Icons.wb_sunny,
          label: themeProvider.isDark ? l.darkMode : l.lightMode,
          trailing: Switch(
            value: themeProvider.isDark,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                themeProvider.toggleTheme();
              });
            },
          ),
          onTap: () {
            setState(() {
              themeProvider.toggleTheme();
            });
          },
        ),

        // LOG OUT
        _buildMenuItem(
          icon: Icons.logout,
          label: l.logOut,
          isDanger: true,
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(S l) {
    String currentLang = Localizations.localeOf(context).languageCode;

    return _buildMenuItem(
      icon: Icons.language,
      label: l.language,
      trailing: DropdownButton<String>(
        value: currentLang,
        underline: const SizedBox(),
        dropdownColor: AppColors.surface(context),
        items: [
          DropdownMenuItem(
            value: 'es',
            child: Text(
              'Español',
              style: TextStyle(color: AppColors.textPrimary(context)),
            ),
          ),
          DropdownMenuItem(
            value: 'en',
            child: Text(
              'English',
              style: TextStyle(color: AppColors.textPrimary(context)),
            ),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          MyApp.setLocale(context, Locale(value));
          setState(() {});
        },
      ),
      onTap: () {},
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDanger
              ? AppColors.passwordWeak
              : AppColors.textSecondary(context),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isDanger
                ? AppColors.passwordWeak
                : AppColors.textPrimary(context),
            fontSize: 14,
          ),
        ),
        trailing:
            trailing ??
            (isDanger
                ? null
                : Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary(context),
                    size: 20,
                  )),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['firstName'] ?? '';
    final lastName = _userData?['lastName'] ?? '';

    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder(context),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.editProfile,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.firstName,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: firstNameController,
              style: TextStyle(color: AppColors.textPrimary(context)),
              decoration: InputDecoration(
                hintText: l.enterFirstName,
                hintStyle: TextStyle(color: AppColors.textSecondary(context)),
                filled: true,
                fillColor: AppColors.inputBorder(context).withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.lastName,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: lastNameController,
              style: TextStyle(color: AppColors.textPrimary(context)),
              decoration: InputDecoration(
                hintText: l.enterLastName,
                hintStyle: TextStyle(color: AppColors.textSecondary(context)),
                filled: true,
                fillColor: AppColors.inputBorder(context).withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  await UserService.updateUserName(
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  _loadUser();
                },
                child: Text(
                  l.saveChanges,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
