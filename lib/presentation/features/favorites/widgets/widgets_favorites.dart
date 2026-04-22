import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';

class FavoritesHeader extends StatelessWidget {
  final S strings;

  const FavoritesHeader({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return SimpleHeader(title: strings.favorites);
  }
}

class FavoritesEmptyState extends StatelessWidget {
  final S strings;

  const FavoritesEmptyState({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppEmojis.getUI('empty_fav'),
            style: const TextStyle(fontSize: 50),
          ),
          const SizedBox(height: 10),
          Text(
            strings.favorites_empty,
            style: TextStyle(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteProjectItem extends StatelessWidget {
  final Map<String, dynamic> project;
  final S strings;
  final Color Function(String) getStatusColor;
  final String Function(String, S) getStatusLabel;
  final Function(String) onRemoveFavorite;

  const FavoriteProjectItem({
    super.key,
    required this.project,
    required this.strings,
    required this.getStatusColor,
    required this.getStatusLabel,
    required this.onRemoveFavorite,
  });

  @override
  Widget build(BuildContext context) {
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
          top: 5,
          right: 5,
          child: IconButton(
            icon: Text(
              AppEmojis.favoriteActive,
              style: const TextStyle(fontSize: 22),
            ),
            onPressed: () => onRemoveFavorite(projectId),
          ),
        ),
      ],
    );
  }
}