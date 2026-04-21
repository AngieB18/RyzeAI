import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/user_service.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import 'privacy_screen.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../styles/screens/style_selection_sheet.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../core/constants/app_assets.dart';

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
    // 1. First, try to get data from the local session metadata (Instant)
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null && currentUser.userMetadata != null) {
      setState(() {
        _userData = {
          'first_name': currentUser.userMetadata?['first_name'] ?? currentUser.userMetadata?['firstName'],
          'last_name': currentUser.userMetadata?['last_name'] ?? currentUser.userMetadata?['lastName'],
          'photoUrl': currentUser.userMetadata?['photo_url'] ?? currentUser.userMetadata?['photoUrl'],
          'email': currentUser.email,
        };
      });
    }

    // 2. Then, fetch the fresh data from the database (Background)
    final data = await UserService.getCurrentUserData();
    if (mounted && data != null) {
      setState(() {
        _userData = data;
        _loading = false;
      });
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }

  void _showFullPhoto(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image(
                image: imageProvider,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName = _userData?['lastName'] ?? _userData?['last_name'] ?? '';
    final email =
        _userData?['email'] ?? Supabase.instance.client.auth.currentUser?.email ?? '';
    final initials = UserService.getInitials(firstName, lastName);
    
    final rawName = '$firstName $lastName'.trim();
    final fullName = rawName.isNotEmpty 
        ? rawName.split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '').join(' ')
        : 'User';

    final bio = _userData?['bio'] ?? 'Work hard in silence. Let your success be the noise.';

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            _buildPremiumHeader(l, fullName, initials),
            
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // User Lifestyle Styles Section
                  _buildMyStyles(l),
                  const SizedBox(height: 16),

                  
                  _buildMenuCard([
                    _buildMenuRow(
                      icon: Icons.person_outline,
                      label: l.editProfile,
                      onTap: () => _showEditProfileSheet(context),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),

                  
                  _buildMenuCard([
                    _buildMenuRow(
                      icon: Icons.lock_outline,
                      label: Localizations.localeOf(context).languageCode == 'es' ? 'Privacidad' : 'Privacy',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PrivacyScreen())),
                    ),
                    _buildMenuRow(
                      icon: Icons.language,
                      label: l.language,
                      trailing: _buildLangDropdown(l),
                      onTap: () {},
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),

                  
                  _buildMenuCard([
                    _buildMenuRow(
                      icon: themeProvider.isDark
                          ? Icons.nightlight_round
                          : Icons.wb_sunny_outlined,
                      label: themeProvider.isDark ? l.darkMode : l.lightMode,
                      trailing: Switch(
                        value: themeProvider.isDark,
                        activeColor: AppColors.primarySoft,
                        onChanged: (val) async {
                          await themeProvider.toggleTheme();
                          if (mounted) setState(() {});
                        },
                      ),
                      onTap: () async {
                        await themeProvider.toggleTheme();
                        if (mounted) setState(() {});
                      },
                    ),
                    _buildMenuRow(
                      icon: Icons.help_outline,
                      label: l.helpSupport,
                      onTap: () => _showHelpSheet(context),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),

                
                  _buildMenuCard([
                    _buildMenuRow(
                      icon: Icons.logout,
                      label: l.logOut,
                      isDanger: true,
                      isLast: true,
                      onTap: () async {
                        await Supabase.instance.client.auth.signOut();
                        if (!mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      },
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PREMIUM HEADER (SIDE-BY-SIDE LAYOUT) ──────────────────
  Widget _buildPremiumHeader(S l, String fullName, String initials) {
    final photoUrl = _userData?['photoUrl'] as String?;
    ImageProvider? imageProvider;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('data:image')) {
        final base64Data = photoUrl.split(',').last;
        imageProvider = MemoryImage(base64Decode(base64Data));
      } else if (!photoUrl.endsWith('.svg')) {
        imageProvider = NetworkImage(photoUrl);
      }
    }

    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(AppAssets.profileCover),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Large Avatar
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: AppColors.primarySoft,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Text(
                        initials.isNotEmpty ? initials : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            
            // Centered Name
            Text(
              fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 3))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── MENU CARD GROUP ────────────────────────────────────────
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
    bool isDanger = false,
    bool isLast = false,
  }) {
    final color = isDanger ? AppColors.passwordWeak : AppColors.textPrimary(context);
    final iconColor = isDanger ? AppColors.passwordWeak : AppColors.primary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 19),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                trailing ??
                    Icon(Icons.chevron_right_rounded,
                        color: AppColors.textSecondary(context), size: 20),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 68,
            endIndent: 18,
            color: AppColors.inputBorder(context).withOpacity(0.5),
          ),
      ],
    );
  }

  Widget _buildLangDropdown(S l) {
    final currentLang = Localizations.localeOf(context).languageCode;
    return DropdownButton<String>(
      value: currentLang,
      underline: const SizedBox(),
      dropdownColor: AppColors.surface(context),
      style: TextStyle(color: AppColors.textPrimary(context), fontSize: 14),
      items: const [
        DropdownMenuItem(value: 'es', child: Text('Español')),
        DropdownMenuItem(value: 'en', child: Text('English')),
      ],
      onChanged: (value) {
        if (value == null) return;
        MyApp.setLocale(context, Locale(value));
        setState(() {});
      },
    );
  }

  Widget _buildMyStyles(S l) {
    final styles = List<String>.from(_userData?['styles'] ?? []);

    final styleData = {
      'modern': {'icon': '🏠', 'label': l.styleModern},
      'natural': {'icon': '🌿', 'label': l.styleNatural},
      'minimal': {'icon': '🕯️', 'label': l.styleMinimal},
      'colorful': {'icon': '🎨', 'label': l.styleColorful},
      'rustic': {'icon': '🪵', 'label': l.styleRustic},
      'scandinavian': {'icon': '❄️', 'label': l.styleScandinavian},
      'traditional': {'icon': '🏛️', 'label': l.styleTraditional},
      'japanese': {'icon': '🎌', 'label': l.styleJapanese},
      'contemporary': {'icon': '⚡', 'label': l.styleContemporary},
      'bohemian': {'icon': '🌸', 'label': l.styleBohemian},
      'farmhouse': {'icon': '🚜', 'label': l.styleFarmhouse},
      'vintage': {'icon': '📻', 'label': l.styleVintage},
      'industrial': {'icon': '🔧', 'label': l.styleIndustrial},
      'retro': {'icon': '🎪', 'label': l.styleRetro},
      'cyberpunk': {'icon': '🤖', 'label': l.styleCyberpunk},
      'christmas': {'icon': '🎄', 'label': l.styleChristmas},
      'tropical': {'icon': '🌴', 'label': l.styleTropical},
      'brutalist': {'icon': '🧱', 'label': l.styleBrutalist},
      'southwest': {'icon': '🌞', 'label': l.styleSouthwest},
      'baroque': {'icon': '👑', 'label': l.styleBaroque},
      'futuristic': {'icon': '🚀', 'label': l.styleFuturistic},
      'colonial': {'icon': '🏰', 'label': l.styleColonial},
      'rococo': {'icon': '💎', 'label': l.styleRococo},
      'valentine': {'icon': '💝', 'label': l.styleValentine},
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.myStyles,
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final currentStyles = List<String>.from(
                    _userData?['styles'] ?? [],
                  );
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => StyleSelectionSheet(
                      initialSelected: currentStyles,
                      onSaved: _loadUser,
                    ),
                  );
                },
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          styles.isEmpty
              ? Text(
                  l.noStylesSelected,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: styles.map((key) {
                    final data = styleData[key];
                    if (data == null) return const SizedBox();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data['icon']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            data['label']!,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }


  void _showEditProfileSheet(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName = _userData?['lastName'] ?? _userData?['last_name'] ?? '';
    final currentEmail =
        _userData?['email'] ?? Supabase.instance.client.auth.currentUser?.email ?? '';

    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);
    final newEmailController = TextEditingController();
    final passwordController = TextEditingController();
    bool showEmailFields = false;
    bool obscurePassword = true;

    final List<String> defaultAvatars = AppAssets.defaultAvatars;

    String currentPhotoUrl = _userData?['photoUrl'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
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

                // ── SECCIÓN DE AVATARES PREDEFINIDOS ──────────────
                Text(
                  'Selecciona tu Avatar', // O l.selectAvatar si lo añades a l10n
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: defaultAvatars.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final avatarUrl = defaultAvatars[index];
                      final isSelected = currentPhotoUrl == avatarUrl;

                      return GestureDetector(
                        onTap: () async {
                          setModalState(() => currentPhotoUrl = avatarUrl);
                          final successUrl = await UserService.uploadProfilePhoto(
                            null, // Pasamos null para indicar que usamos URL
                            avatarUrl: avatarUrl,
                          );
                          if (successUrl != null) {
                            _loadUser(); // Recargar datos del perfil
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8)]
                                : [],
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.inputBorder(context).withOpacity(0.2),
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l.firstName,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                _buildSheetTextField(
                  context: context,
                  controller: firstNameController,
                  hint: l.enterFirstName,
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
                _buildSheetTextField(
                  context: context,
                  controller: lastNameController,
                  hint: l.enterLastName,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () =>
                      setModalState(() => showEmailFields = !showEmailFields),
                  child: Row(
                    children: [
                      Icon(
                        showEmailFields
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l.newEmail,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showEmailFields) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l.emailChangeInfo,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.email,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder(context).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      currentEmail,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.newEmail,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildSheetTextField(
                    context: context,
                    controller: newEmailController,
                    hint: l.enterNewEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.currentPassword,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildSheetTextField(
                    context: context,
                    controller: passwordController,
                    hint: l.enterCurrentPassword,
                    obscureText: obscurePassword,
                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.textSecondary(context),
                        size: 18,
                      ),
                      onPressed: () => setModalState(
                        () => obscurePassword = !obscurePassword,
                      ),
                    ),
                  ),
                ],
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
                      if (showEmailFields &&
                          newEmailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        try {
  final supabase = Supabase.instance.client;

  // 1. Reautenticar (Supabase way)
  await supabase.auth.signInWithPassword(
    email: currentEmail,
    password: passwordController.text.trim(),
  );

  // 2. Actualizar email
  await supabase.auth.updateUser(
    UserAttributes(
      email: newEmailController.text.trim(),
    ),
  );

  // (opcional) actualizar tu tabla de usuario si la usas
  await UserService.updateUserEmail(
    newEmailController.text.trim(),
  );

  if (!mounted) return;
  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l.emailChanged),
      backgroundColor: AppColors.passwordStrong,
    ),
  );
} catch (e) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.toString()),
      backgroundColor: AppColors.passwordWeak,
    ),
  );
}
                      } else {
                        if (!mounted) return;
                        Navigator.pop(context);
                        _loadUser();
                      }
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
        ),
      ),
    );
  }

  Widget _buildSheetTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: AppColors.textPrimary(context)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textSecondary(context)),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.inputBorder(context).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  void _showHelpSheet(BuildContext context) {
    final l = S.of(context);
    int expandedFaq = -1;

    final faqs = [
      {'q': l.faqQ1, 'a': l.faqA1},
      {'q': l.faqQ2, 'a': l.faqA2},
      {'q': l.faqQ3, 'a': l.faqA3},
      {'q': l.faqQ4, 'a': l.faqA4},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inputBorder(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.help_outline_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l.helpSupportTitle,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildHelpSection(
                      context,
                      l.faq,
                      Icons.question_answer_outlined,
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(faqs.length, (i) {
                      final isExpanded = expandedFaq == i;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.background(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                faqs[i]['q']!,
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primary,
                              ),
                              onTap: () => setSheetState(() {
                                expandedFaq = isExpanded ? -1 : i;
                              }),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  14,
                                ),
                                child: Text(
                                  faqs[i]['a']!,
                                  style: TextStyle(
                                    color: AppColors.textSecondary(context),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    _buildHelpSection(
                      context,
                      l.termsAndConditions,
                      Icons.description_outlined,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l.termsContent,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildHelpSection(
                      context,
                      l.privacyPolicy,
                      Icons.privacy_tip_outlined,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l.privacyContent,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
