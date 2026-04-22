import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

// ─────────────────────────────────────────
// Header
// ─────────────────────────────────────────
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
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
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

// ─────────────────────────────────────────
// Imagen capturada
// ─────────────────────────────────────────
class CapturedImagePreview extends StatelessWidget {
  final File image;
  const CapturedImagePreview({super.key, required this.image});

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

// ─────────────────────────────────────────
// Mis Estilos — chips seleccionables
// ─────────────────────────────────────────
class UserStylesChips extends StatelessWidget {
  final List<String> styles;
  final String? selectedStyle;
  final ValueChanged<String> onSelect;

  const UserStylesChips({
    super.key,
    required this.styles,
    required this.selectedStyle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (styles.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mis Estilos',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: styles.map((style) {
              final isSelected = selectedStyle == style;
              return GestureDetector(
                onTap: () => onSelect(style),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    // Capitaliza primera letra
                    style[0].toUpperCase() + style.substring(1),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Selector de paleta de colores
// ─────────────────────────────────────────
class ColorPaletteSelector extends StatelessWidget {
  final List<Map<String, dynamic>> palettes;
  final String? selectedPalette;
  final ValueChanged<String> onSelect;

  const ColorPaletteSelector({
    super.key,
    required this.palettes,
    required this.selectedPalette,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Color Palette',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: palettes.map((palette) {
              final isSelected = selectedPalette == palette['key'];
              final colors = palette['colors'] as List<Color>;
              return GestureDetector(
                onTap: () => onSelect(palette['key']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.surface(context),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: colors
                            .map((c) => Container(
                                  width: 18,
                                  height: 18,
                                  margin: const EdgeInsets.only(right: 2),
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        palette['label'],
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Grid de categorías (Sala, Oficina, etc.)
// ─────────────────────────────────────────
class CategoryGrid extends StatelessWidget {
  final Map<String, Map<String, dynamic>> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSelect;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Elige un espacio',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '¿Dónde quieres aplicar este estilo?',
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: categories.entries.map((entry) {
              final isSelected = selectedCategory == entry.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : AppColors.surface(context),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          entry.value['icon'],
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.value['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary(context),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Sub-espacios (Zona TV, Escritorio, etc.)
// ─────────────────────────────────────────
class SpaceChips extends StatelessWidget {
  final List<dynamic> spaces;
  final String? selectedSpace;
  final ValueChanged<String> onSelect;

  const SpaceChips({
    super.key,
    required this.spaces,
    required this.selectedSpace,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        children: spaces.map<Widget>((space) {
          final label = space['label'] as String;
          final isSelected = selectedSpace == label;
          return GestureDetector(
            onTap: () => onSelect(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surface(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBorder(context),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(space['icon'],
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary(context),
                      fontSize: 13,
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

// ─────────────────────────────────────────
// Botón Generar Ideas
// ─────────────────────────────────────────
class GenerateButton extends StatelessWidget {
  final bool generating;
  final VoidCallback onPressed;

  const GenerateButton({
    super.key,
    required this.generating,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: generating ? null : onPressed,
          icon: generating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('✨', style: TextStyle(fontSize: 16)),
          label: Text(
            generating ? 'Generando...' : 'Generar Ideas',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}