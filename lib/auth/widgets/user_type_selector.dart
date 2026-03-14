// lib/auth/widgets/user_type_selector.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum UserType { HOME, DESIGNER, STORE }

class UserTypeSelector extends StatelessWidget {
  final UserType selected;
  final ValueChanged<UserType> onChanged;

  const UserTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildOption(UserType.HOME, '🏠', 'Hogar'),
        const SizedBox(width: 8),
        _buildOption(UserType.DESIGNER, '✏️', 'Diseñador'),
        const SizedBox(width: 8),
        _buildOption(UserType.STORE, '🎁', 'Tienda'),
      ],
    );
  }

  Widget _buildOption(UserType type, String icon, String label) {
    final isSelected = selected == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.inputBorder,
            ),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
