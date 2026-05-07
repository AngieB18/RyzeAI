import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';
export 'projects_empty_state.dart';
class ProjectsHeader extends StatelessWidget {
  final S strings;

  const ProjectsHeader({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return SimpleHeader(
      title: strings.projects,
    );
  }
}

class ProjectItem extends StatelessWidget {
  final Map<String, dynamic> project;
  final S strings;
  final Color Function(bool) getStatusColor;
  final String Function(bool, S) getStatusLabel;
  final Function(String, bool) onToggleFavorite;
  final VoidCallback? onTap;

  const ProjectItem({
    super.key,
    required this.project,
    required this.strings,
    required this.getStatusColor,
    required this.getStatusLabel,
    required this.onToggleFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = project['is_favorite'] ?? false;
    final String projectId = project['id'];
    final bool isPublic = project['public_state'] ?? false;
    final String projectName = project['name_projects'] ?? strings.projects_untitled;

    return Stack(
      children: [
        ProjectCard(
          icon: '🎨',
          name: projectName,
          items: strings.projects_styles_count(1),
          status: getStatusLabel(isPublic, strings),
          statusColor: getStatusColor(isPublic),
          onTap: onTap,
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