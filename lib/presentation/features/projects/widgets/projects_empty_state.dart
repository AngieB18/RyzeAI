import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';

class ProjectsEmptyState extends StatelessWidget {
  final VoidCallback onCameraTap;

  const ProjectsEmptyState({super.key, required this.onCameraTap});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            strings.projects_empty_title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.projects_empty_subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary(context),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _buildStepCard(
            context: context,
            number: '1',
            text: strings.projects_empty_step1,
            numberColor: const Color(0xFFF07137), // Primary Orange
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            context: context,
            number: '2',
            text: strings.projects_empty_step2,
            numberColor: const Color(0xFFE89A84), // Soft Peach/Orange
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            context: context,
            number: '3',
            text: strings.projects_empty_step3,
            numberColor: const Color(0xFF67946E), // Muted Green
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: onCameraTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE65C00), Color(0xFFF9D423)], // Orange to yellow gradient
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  strings.projects_empty_button,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required BuildContext context,
    required String number,
    required String text,
    required Color numberColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.inputBorder(context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: numberColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                color: numberColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
