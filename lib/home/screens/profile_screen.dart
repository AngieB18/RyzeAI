// lib/home/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/user_service.dart';
import '../../generated/l10n.dart';

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
            _buildHeader(fullName, email, initials),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoCard(),
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

  Widget _buildHeader(String fullName, String email, String initials) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 70, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF2A1F1A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _loading
              ? const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFF3A3A3C),
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
              ? const SizedBox(
                  width: 120,
                  height: 20,
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFF3A3A3C),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : Text(
                  fullName.isNotEmpty ? fullName : 'User',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              color: AppColors.textSecondary,
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
            child: const Text(
              'Home User',
              style: TextStyle(
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('3', 'Projects'),
          _buildDivider(),
          _buildStat('12', 'Favorites'),
          _buildDivider(),
          _buildStat('2', 'Rooms'),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: const Color(0xFF3A3A3C));
  }

  Widget _buildMenuSection(BuildContext context, S l) {
    final items = [
      {'icon': Icons.person_outline, 'label': 'Edit Profile'},
      {'icon': Icons.notifications_none, 'label': 'Notifications'},
      {'icon': Icons.lock_outline, 'label': 'Privacy'},
      {'icon': Icons.help_outline, 'label': 'Help & Support'},
      {'icon': Icons.logout, 'label': 'Log Out', 'danger': true},
    ];

    return Column(
      children: items.map((item) {
        final isDanger = item['danger'] == true;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: isDanger
                  ? AppColors.passwordWeak
                  : AppColors.textSecondary,
              size: 22,
            ),
            title: Text(
              item['label'] as String,
              style: TextStyle(
                color: isDanger
                    ? AppColors.passwordWeak
                    : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            trailing: isDanger
                ? null
                : const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
            onTap: isDanger
                ? () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  }
                : () {},
          ),
        );
      }).toList(),
    );
  }
}
