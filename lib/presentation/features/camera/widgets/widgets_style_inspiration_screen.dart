// widgets_style_inspiration_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class StyleInspirationHeader extends StatelessWidget {
  const StyleInspirationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Inspírate',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 6),
          const Text('✨', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class CapturedImagePreview extends StatelessWidget {
  final File image;

  const CapturedImagePreview({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        image,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String badge;
  final Color badgeColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.badge,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class CameraChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final bool selected;
  final VoidCallback onTap;

  const CameraChip({
    super.key,
    required this.icon,
    required this.label,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: (MediaQuery.of(context).size.width - 56) / 2,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.inputBorder(context),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? AppColors.primary
                  : AppColors.textSecondary(context),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.primary
                    : AppColors.textPrimary(context),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nuevos widgets movidos desde StyleInspirationScreen

class NameProjectInput extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputDecoration decoration;

  const NameProjectInput({
    super.key,
    required this.controller,
    this.textStyle,
    this.hintStyle,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: textStyle,
      decoration: decoration,
    );
  }
}

class RoomSelector extends StatelessWidget {
  final List<Map<String, dynamic>> rooms;
  final String? selectedRoomId;
  final Function(String) onRoomSelected;
  final String Function(dynamic) textTranslator;
  final Color? primaryColor;
  final Color? surfaceColor;
  final Color? inputBorderColor;
  final Color? textColor;

  const RoomSelector({
    super.key,
    required this.rooms,
    required this.selectedRoomId,
    required this.onRoomSelected,
    required this.textTranslator,
    this.primaryColor,
    this.surfaceColor,
    this.inputBorderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final room = rooms[i];
          final roomId = room['id'].toString();
          final selected = selectedRoomId == roomId;

          return GestureDetector(
            onTap: () {
              onRoomSelected(roomId);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? primaryColor ?? AppColors.primary
                    : surfaceColor ?? AppColors.surface(context),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected
                      ? primaryColor ?? AppColors.primary
                      : inputBorderColor ?? AppColors.inputBorder(context),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    room['icon_room']?.toString() ?? '🏠',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    textTranslator(room['name_type_room']),
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : textColor ?? AppColors.textPrimary(context),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
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

class StyleSelector extends StatelessWidget {
  final List<Map<String, dynamic>> styles;
  final String? selectedStyleId;
  final Function(String) onStyleSelected;
  final String Function(dynamic) textTranslator;
  final Color? primaryColor;
  final Color? surfaceColor;
  final Color? textColor;

  const StyleSelector({
    super.key,
    required this.styles,
    required this.selectedStyleId,
    required this.onStyleSelected,
    required this.textTranslator,
    this.primaryColor,
    this.surfaceColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final style = styles[i];
          final styleId = style['id'].toString();
          final selected = selectedStyleId == styleId;

          return GestureDetector(
            onTap: () {
              onStyleSelected(styleId);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? primaryColor ?? AppColors.primary
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: surfaceColor ?? AppColors.surface(context),
                      child: Center(
                        child: Text(
                          style['icon']?.toString() ?? '✨',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.75),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 9,
                      left: 0,
                      right: 0,
                      child: Text(
                        textTranslator(style['name']),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (selected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaletteSelector extends StatelessWidget {
  final List<Map<String, dynamic>> palettes;
  final String? selectedPaletteId;
  final Function(String) onPaletteSelected;
  final String Function(dynamic) textTranslator;
  final List<Color> Function(dynamic) colorParser;
  final Color? primaryColor;
  final Color? surfaceColor;
  final Color? inputBorderColor;
  final Color? textColor;

  const PaletteSelector({
    super.key,
    required this.palettes,
    required this.selectedPaletteId,
    required this.onPaletteSelected,
    required this.textTranslator,
    required this.colorParser,
    this.primaryColor,
    this.surfaceColor,
    this.inputBorderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: palettes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final palette = palettes[i];
          final paletteId = palette['id'].toString();
          final selected = selectedPaletteId == paletteId;
          final colors = colorParser(palette['colors_palette']);

          return GestureDetector(
            onTap: () {
              onPaletteSelected(paletteId);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 158,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: surfaceColor ?? AppColors.surface(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? primaryColor ?? AppColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: colors
                        .take(4)
                        .map(
                          (c) => Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    textTranslator(palette['name_palette']),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor ?? AppColors.textPrimary(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

class FeatureSelector extends StatelessWidget {
  final List<Map<String, dynamic>> features;
  final Set<String> selectedFeatures;
  final Function(String) onFeatureToggle;
  final String Function(String?) featureIcon;
  final String Function(dynamic) textTranslator;
  final Color? primaryColor;
  final Color? surfaceColor;
  final Color? inputBorderColor;
  final Color? textColor;

  const FeatureSelector({
    super.key,
    required this.features,
    required this.selectedFeatures,
    required this.onFeatureToggle,
    required this.featureIcon,
    required this.textTranslator,
    this.primaryColor,
    this.surfaceColor,
    this.inputBorderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final feature = features[i];
          final featureId = feature['id'].toString();
          final selected = selectedFeatures.contains(featureId);

          return GestureDetector(
            onTap: () {
              onFeatureToggle(featureId);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              decoration: BoxDecoration(
                color: surfaceColor ?? AppColors.surface(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? primaryColor ?? AppColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    featureIcon(feature['icon_feature']?.toString()),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    textTranslator(feature['name_feature']),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor ?? AppColors.textPrimary(context),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? primaryColor ?? AppColors.primary
                            : inputBorderColor ?? AppColors.inputBorder(context),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      selected ? Icons.check : Icons.add,
                      size: 13,
                      color: selected
                          ? primaryColor ?? AppColors.primary
                          : textColor ?? AppColors.textSecondary(context),
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

class PromptInput extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final InputDecoration decoration;
  final int maxLength;

  const PromptInput({
    super.key,
    required this.controller,
    this.textStyle,
    this.hintStyle,
    required this.decoration,
    this.maxLength = 250,
  });

  @override
  Widget build(BuildContext context) {
      return TextField(
        controller: controller,
        maxLines: 3,
        maxLength: maxLength,
        style: textStyle,
        decoration: decoration.copyWith(
          counterStyle: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 12,
          ),
        ),
      );
    }
  }

class GenerateButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final Color? primaryColor;
  final Color? disabledBackgroundColor;

  const GenerateButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    this.primaryColor,
    this.disabledBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor ?? AppColors.primary,
          disabledBackgroundColor:
              disabledBackgroundColor ?? AppColors.primary.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          '✨ Generar diseño',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}