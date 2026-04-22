import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/generated/l10n.dart';

/// ===============================
/// TITLE
/// ===============================
class RecoverPasswordTitle extends StatelessWidget {
  const RecoverPasswordTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Text(
      l10n.recoverPassword,
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(context),
      ),
    );
  }
}

/// ===============================
/// DESCRIPTION TEXT
/// ===============================
class RecoverPasswordSubtitle extends StatelessWidget {
  const RecoverPasswordSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Text(
      l10n.enterYourEmail,
      style: TextStyle(
        color: AppColors.textSecondary(context),
      ),
    );
  }
}

/// ===============================
/// EMAIL FIELD
/// ===============================
class RecoverPasswordEmailField extends StatelessWidget {
  final TextEditingController controller;

  const RecoverPasswordEmailField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.textPrimary(context)),
      decoration: _inputDecoration(
        context: context,
        hint: l10n.email,
        icon: Icons.email_outlined,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: AppColors.surface(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }
}

/// ===============================
/// SUBMIT BUTTON
/// ===============================
class RecoverPasswordButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const RecoverPasswordButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                l10n.sendEmail,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}