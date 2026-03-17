// lib/home/screens/projects_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../generated/l10n.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final projects = [
      {
        'icon': '🛋️',
        'name': 'Living Room',
        'items': '8 items',
        'status': 'In progress',
        'color': AppColors.passwordMedium,
      },
      {
        'icon': '🛏️',
        'name': 'Bedroom',
        'items': '5 items',
        'status': 'Completed',
        'color': AppColors.passwordStrong,
      },
      {
        'icon': '🍳',
        'name': 'Kitchen',
        'items': '3 items',
        'status': 'Draft',
        'color': AppColors.textSecondary,
      },
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: projects.length,
              itemBuilder: (_, i) => _buildProjectCard(projects[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(S l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 70, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2A1F1A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l.projects,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'New',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF3A2218),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                project['icon'] as String,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['name'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project['items'] as String,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (project['color'] as Color).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              project['status'] as String,
              style: TextStyle(
                color: project['color'] as Color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
