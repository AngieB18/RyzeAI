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