import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileWidgetsMenuCard extends StatelessWidget {
  final List<Widget> children;

  const ProfileWidgetsMenuCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
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
}

class ProfileWidgetsMenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDanger;
  final bool isLast;

  const ProfileWidgetsMenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isDanger = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
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
}

class ProfileWidgetsLangDropdown extends StatelessWidget {
  final Function(String) onLanguageChanged;

  const ProfileWidgetsLangDropdown({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
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
        onLanguageChanged(value);
      },
    );
  }
}
