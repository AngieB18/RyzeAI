import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool required;
  final String badge;

  const SectionHeader({
    super.key,
    required this.title,
    required this.required,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: required
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.inputBorder(context).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: TextStyle(
              color: required
                  ? AppColors.primary
                  : AppColors.textSecondary(context),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
