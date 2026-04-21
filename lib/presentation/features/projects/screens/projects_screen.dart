// lib/home/screens/projects_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';

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
        'color': AppColors.darkTextSecondary,
      },
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: projects.length,
              itemBuilder: (ctx, i) => _buildProjectCard(ctx, projects[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, S l) {
    return SimpleHeader(
      title: l.projects,
      trailing: Container(
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
    );
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    return ProjectCard(
      icon: project['icon'] as String,
      name: project['name'] as String,
      items: project['items'] as String,
      status: project['status'] as String,
      statusColor: project['color'] as Color,
    );
  }
}