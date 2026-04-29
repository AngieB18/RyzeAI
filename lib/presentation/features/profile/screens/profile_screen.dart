import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/user_service.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import 'privacy_screen.dart';
import '../widgets/profile_widgets_header.dart';
import '../widgets/profile_widgets_menu.dart';
import '../widgets/profile_widgets_styles.dart';
import '../widgets/profile_widgets_edit_sheet.dart';
import '../widgets/profile_widgets_help_sheet.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName = _userData?['lastName'] ?? _userData?['last_name'] ?? '';
    final initials = UserService.getInitials(firstName, lastName);
    
    final rawName = '$firstName $lastName'.trim();
    final fullName = rawName.isNotEmpty 
        ? rawName.split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '').join(' ')
        : 'User';

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileWidgetsHeader(
              userData: _userData,
              fullName: fullName,
              initials: initials,
            ),
            
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileWidgetsStyles(
                    userData: _userData,
                    onRefresh: _loadUser,
                  ),
                  const SizedBox(height: 16),

                  ProfileWidgetsMenuCard(children: [
                    ProfileWidgetsMenuRow(
                      icon: Icons.person_outline,
                      label: l.editProfile,
                      onTap: () => ProfileWidgetsEditSheet.show(context, userData: _userData, onRefresh: _loadUser),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),

                  ProfileWidgetsMenuCard(children: [
                    ProfileWidgetsMenuRow(
                      icon: Icons.lock_outline,
                      label: Localizations.localeOf(context).languageCode == 'es' ? 'Privacidad' : 'Privacy',
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PrivacyScreen())),
                    ),
                    ProfileWidgetsMenuRow(
                      icon: Icons.language,
                      label: l.language,
                      trailing: ProfileWidgetsLangDropdown(
                          onLanguageChanged: (value) async {
                            await UserService.updateUserLanguage(value);

                            if (!mounted) return;

                            MyApp.setLocale(context, Locale(value));

                            setState(() {
                              _userData?['language'] = value;
                            });
                          },
                        ),
                                              onTap: () {},
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),

                  ProfileWidgetsMenuCard(children: [
                    ProfileWidgetsMenuRow(
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
                    ProfileWidgetsMenuRow(
                      icon: Icons.help_outline,
                      label: l.helpSupport,
                      onTap: () => ProfileWidgetsHelpSheet.show(context),
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 16),

                  ProfileWidgetsMenuCard(children: [
                    ProfileWidgetsMenuRow(
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
}
