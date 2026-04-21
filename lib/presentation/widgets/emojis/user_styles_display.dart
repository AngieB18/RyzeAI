import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class UserStylesDisplay extends StatelessWidget {
  final List<String> userStyles;
  final List<Map<String, String>> allStyles;
  final Function(String) getStyleLabel;

  const UserStylesDisplay({
    super.key,
    required this.userStyles,
    required this.allStyles,
    required this.getStyleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: userStyles.map((style) {
        final styleData = allStyles.firstWhere(
          (s) => s['key'] == style,
          orElse: () => {'key': style, 'icon': '🎨'},
        );
        final label = getStyleLabel(style);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(styleData['icon']!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 14,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
