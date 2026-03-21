// lib/home/screens/privacy_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../generated/l10n.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildOption(
                      context: context,
                      icon: Icons.lock_reset_rounded,
                      title: l.changePassword,
                      subtitle: l.changePasswordDesc,
                      color: AppColors.primary,
                      onTap: () => _sendResetEmail(context, l),
                    ),
                    const SizedBox(height: 12),
                    _buildOption(
                      context: context,
                      icon: Icons.delete_forever_rounded,
                      title: l.deleteAccount,
                      subtitle: l.deleteAccountDesc,
                      color: AppColors.passwordWeak,
                      onTap: () => _confirmDeleteAccount(context, l),
                      isDanger: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, S l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary(context),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l.privacyTitle,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
          border: isDanger
              ? Border.all(color: AppColors.passwordWeak.withOpacity(0.3))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDanger
                          ? AppColors.passwordWeak
                          : AppColors.textPrimary(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendResetEmail(BuildContext context, S l) async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) return;

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.emailSent),
          backgroundColor: AppColors.passwordStrong,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  void _confirmDeleteAccount(BuildContext context, S l) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l.deleteAccount,
          style: TextStyle(
            color: AppColors.passwordWeak,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          l.deleteAccountConfirm,
          style: TextStyle(color: AppColors.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l.cancel,
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.passwordWeak,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.currentUser?.delete();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              } catch (e) {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: AppColors.passwordWeak,
                  ),
                );
              }
            },
            child: Text(l.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
