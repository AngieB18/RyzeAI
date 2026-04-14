// lib/auth/widgets/password_strength_indicator.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/validators/register_validators.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = RegisterValidators.passwordStrength(password);
    final color = [
      AppColors.passwordWeak,
      AppColors.passwordMedium,
      AppColors.passwordStrong,
    ][strength];
    final label = [
      'Contraseña débil',
      'Contraseña media',
      'Contraseña fuerte ✓',
    ][strength];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (strength + 1) / 3,
          backgroundColor: AppColors.inputBorder(context),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
