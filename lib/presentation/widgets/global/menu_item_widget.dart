import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDanger;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDanger
              ? AppColors.passwordWeak
              : AppColors.textSecondary(context),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isDanger
                ? AppColors.passwordWeak
                : AppColors.textPrimary(context),
            fontSize: 14,
          ),
        ),
        trailing: trailing ??
            (isDanger
                ? null
                : Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary(context),
                    size: 20,
                  )),
        onTap: onTap,
      ),
    );
  }
}
