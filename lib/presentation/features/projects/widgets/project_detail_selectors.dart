import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';

typedef ProjectDetailTextBuilder = String Function(dynamic item);
typedef ProjectDetailColorsParser = List<Color> Function(dynamic value);

typedef ProjectDetailIconBuilder = String Function(dynamic item);

class ProjectDetailRoomSelector extends StatelessWidget {
  final List<Map<String, dynamic>> rooms;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final ProjectDetailTextBuilder titleBuilder;

  const ProjectDetailRoomSelector({
    super.key,
    required this.rooms,
    required this.selectedId,
    required this.onSelect,
    required this.titleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final room = rooms[i];
          final id = room['id']?.toString();
          final isSelected = id == selectedId;
          return GestureDetector(
            onTap: () => onSelect(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary(context).withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    room['icon_room']?.toString() ?? AppEmojis.defaultRoom,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    titleBuilder(room['name_type_room']),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary(context),
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProjectDetailStylesSelector extends StatelessWidget {
  final List<Map<String, dynamic>> styles;
  final List<String> selected;
  final ValueChanged<List<String>> onUpdate;
  final ProjectDetailTextBuilder titleBuilder;

  const ProjectDetailStylesSelector({
    super.key,
    required this.styles,
    required this.selected,
    required this.onUpdate,
    required this.titleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: styles.map((style) {
        final id = style['id']?.toString() ?? '';
        final isSelected = selected.contains(id);
        return GestureDetector(
          onTap: () {
            final updated = List<String>.from(selected);
            isSelected ? updated.remove(id) : updated.add(id);
            onUpdate(updated);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary(context).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  style['icon']?.toString() ?? AppEmojis.defaultStyle,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(width: 6),
                Text(
                  titleBuilder(style['name']),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary(context),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.check_circle,
                      size: 14, color: Colors.white.withValues(alpha: 0.9)),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ProjectDetailPaletteSelector extends StatelessWidget {
  final List<Map<String, dynamic>> palettes;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final ProjectDetailTextBuilder nameBuilder;
  final ProjectDetailColorsParser parseColors;

  const ProjectDetailPaletteSelector({
    super.key,
    required this.palettes,
    required this.selectedId,
    required this.onSelect,
    required this.nameBuilder,
    required this.parseColors,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: palettes.map((palette) {
        final id = palette['id']?.toString();
        final isSelected = id == selectedId;
        final colors = parseColors(palette['colors_palette']);

        return GestureDetector(
          onTap: () => onSelect(id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary(context).withValues(alpha: 0.15),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: colors.take(5).map((c) {
                    return Container(
                      width: 28,
                      height: 20,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nameBuilder(palette['name_palette']),
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary(context),
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.check_circle, size: 12, color: AppColors.primary),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ProjectDetailFeaturesSelector extends StatelessWidget {
  final List<Map<String, dynamic>> features;
  final List<String> selected;
  final ValueChanged<List<String>> onUpdate;
  final ProjectDetailTextBuilder titleBuilder;

  const ProjectDetailFeaturesSelector({
    super.key,
    required this.features,
    required this.selected,
    required this.onUpdate,
    required this.titleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: features.map((feature) {
        final id = feature['id']?.toString() ?? '';
        final isSelected = selected.contains(id);
        return GestureDetector(
          onTap: () {
            final updated = List<String>.from(selected);
            isSelected ? updated.remove(id) : updated.add(id);
            onUpdate(updated);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary(context).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  feature['icon_feature']?.toString() ?? AppEmojis.defaultFeature,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(width: 6),
                Text(
                  titleBuilder(feature['name_feature']),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary(context),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.check_circle,
                      size: 14, color: Colors.white.withValues(alpha: 0.9)),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
