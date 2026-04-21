import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Widget? trailingIcon;

  const AppHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: onBack,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary(context),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          trailingIcon ?? const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}
