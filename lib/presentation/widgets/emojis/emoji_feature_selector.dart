import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class EmojiFeatureSelector extends StatelessWidget {
  final List<Map<String, dynamic>> sections;
  final List<String> selectedFeatures;
  final Function(String, bool) onFeatureToggled;

  const EmojiFeatureSelector({
    super.key,
    required this.sections,
    required this.selectedFeatures,
    required this.onFeatureToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        final color = section['color'] as Color;
        final features = section['features'] as List<String>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                section['title'] as String,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features.map((feature) {
                final isSelected = selectedFeatures.contains(feature);
                return GestureDetector(
                  onTap: () => onFeatureToggled(feature, !isSelected),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.15)
                          : AppColors.surface(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? color
                            : AppColors.inputBorder(context),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: isSelected
                            ? color
                            : AppColors.textPrimary(context),
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
}
