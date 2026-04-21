import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class ColorPaletteSelector extends StatelessWidget {
  final List<Map<String, dynamic>> palettes;
  final String? selectedPalette;
  final Function(String?) onPaletteSelected;
  final Function(String) getPaletteLabel;

  const ColorPaletteSelector({
    super.key,
    required this.palettes,
    required this.selectedPalette,
    required this.onPaletteSelected,
    required this.getPaletteLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: palettes.map((palette) {
          final isSelected = selectedPalette == palette['key'];
          final label = getPaletteLabel(palette['key'] as String);
          final colors = palette['colors'] as List<Color>;

          return GestureDetector(
            onTap: () => onPaletteSelected(palette['key'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surface(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBorder(context),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: colors
                        .map(
                          (c) => Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 2),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white24,
                                width: 0.5,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary(context),
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
