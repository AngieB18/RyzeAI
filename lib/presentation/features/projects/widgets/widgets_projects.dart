import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';

class ProjectsHeader extends StatelessWidget {
  final S strings;

  const ProjectsHeader({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return SimpleHeader(
      title: strings.projects,
      trailing: GestureDetector(
        onTap: () {
          // navegación crear proyecto
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.add, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                strings.projects_new,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectItem extends StatelessWidget {
  final Map<String, dynamic> project;
  final S strings;
  final Color Function(String) getStatusColor;
  final String Function(String, S) getStatusLabel;
  final Function(String, bool) onToggleFavorite;

  const ProjectItem({
    super.key,
    required this.project,
    required this.strings,
    required this.getStatusColor,
    required this.getStatusLabel,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = project['is_favorite'] ?? false;
    final String projectId = project['id'];

    return Stack(
      children: [
        ProjectCard(
          icon: AppEmojis.getRoom(project['room'] ?? ''),
          name: project['name'] ?? strings.projects_untitled,
          items: strings.projects_styles_count(
            (project['styles'] as List?)?.length ?? 0,
          ),
          status: getStatusLabel(project['status'] ?? '', strings),
          statusColor: getStatusColor(project['status'] ?? ''),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => onToggleFavorite(projectId, isFavorite),
          ),
        ),
      ],
    );
  }
}