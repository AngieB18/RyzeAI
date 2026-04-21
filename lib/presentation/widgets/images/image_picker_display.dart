import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ryzeai/core/constants/app_colors.dart';

class ImagePickerDisplay extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onTap;
  final String loadingText;
  final String hintText;
  final String hintDescription;

  const ImagePickerDisplay({
    super.key,
    required this.selectedImage,
    required this.onTap,
    this.loadingText = 'Cargar imagen',
    this.hintText = 'Cargar imagen',
    this.hintDescription = 'Toma una foto o carga una imagen JPG/PNG',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: selectedImage != null
              ? AppColors.surface(context)
              : AppColors.inputBorder(context).withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedImage != null
                ? AppColors.primary
                : AppColors.inputBorder(context),
            width: 2,
          ),
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  selectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.image_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hintText,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hintDescription,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
