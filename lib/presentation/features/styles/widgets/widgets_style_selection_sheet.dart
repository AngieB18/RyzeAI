import 'package:flutter/material.dart';

class StylesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> styles;
  final List<String> selected;
  final Function(String id) onToggle;

  const StylesGrid({
    super.key,
    required this.styles,
    required this.selected,
    required this.onToggle,
  });

  String _getLabel(BuildContext context, Map<String, dynamic>? nameJson) {
    if (nameJson == null) return '';
    final locale = Localizations.localeOf(context).languageCode;
    return nameJson[locale] ?? nameJson['en'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final textPrimary = theme.textTheme.bodyMedium?.color;
    final textSecondary = theme.textTheme.bodySmall?.color;

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
      children: styles.map((style) {
        final id = style['id'];
        final icon = style['icon'];
        final label = _getLabel(context, style['name']);

        final isSelected = selected.contains(id);
        final maxReached = selected.length >= 4 && !isSelected;

        return GestureDetector(
          onTap: maxReached ? null : () => onToggle(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withOpacity(0.15)
                  : maxReached
                      ? colors.surface.withOpacity(0.5)
                      : colors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: maxReached ? 0.5 : 1,
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? colors.primary
                          : textPrimary,
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: colors.primary,
                    size: 12,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}