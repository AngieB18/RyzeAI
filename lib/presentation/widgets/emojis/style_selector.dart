import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/emojis/app_emojis.dart';

class StyleSelector extends StatelessWidget {
  final List<Map<String, String>> styles;
  final String? selectedStyle;
  final Function(String?) onStyleSelected;
  final Function(String, String) getStyleLabel;

  const StyleSelector({
    super.key,
    required this.styles,
    required this.selectedStyle,
    required this.onStyleSelected,
    required this.getStyleLabel,
  });

  String _getStyleEmoji(String key) => AppEmojis.getStyle(key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: styles.map((style) {
        final isSelected = selectedStyle == style['key'];
        final label = getStyleLabel(style['key']!, 'label');

        return GestureDetector(
          onTap: () => onStyleSelected(style['key']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.surface(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.inputBorder(context),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getStyleEmoji(style['key']!),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary(context),
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
