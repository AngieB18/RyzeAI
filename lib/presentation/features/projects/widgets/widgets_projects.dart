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
  final List<Map<String, dynamic>> rooms;
  final VoidCallback? onTap;

  const ProjectItem({
    super.key,
    required this.project,
    required this.strings,
    required this.rooms,
    this.onTap,
  });

  String _getRoomIcon(String? roomId) {
    if (roomId == null) return '🏠';
    final room = rooms.firstWhere(
      (item) => item['id']?.toString() == roomId,
      orElse: () => {},
    );
    if (room.isNotEmpty) {
      final icon = room['icon_room']?.toString();
      if (icon != null && icon.isNotEmpty) return icon;
    }
    return '🏠';
  }

  String _getPublicStateLabel(bool isPublic) {
    return isPublic ? 'Público' : 'Privado';
  }

  IconData _getPublicStateIcon(bool isPublic) {
    return isPublic ? Icons.public : Icons.lock;
  }

  Color _getPublicStateColor(bool isPublic, BuildContext context) {
    return isPublic ? const Color(0xFF4CAF50) : AppColors.textSecondary(context);
  }

  @override
  Widget build(BuildContext context) {
    final String projectName = project['name_projects'] ?? strings.projects_untitled;
    final String createdAt = project['created_at'] ?? '';
    final String roomId = project['id_type_room']?.toString() ?? '';
    final bool isPublic = project['public_state'] ?? false;

    // Formatear la fecha
    String formattedDate = '';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = '${date.day}/${date.month}/${date.year}';
      } catch (e) {
        formattedDate = createdAt;
      }
    }

    final roomIcon = _getRoomIcon(roomId);
    final stateLabel = _getPublicStateLabel(isPublic);
    final stateIcon = _getPublicStateIcon(isPublic);
    final stateColor = _getPublicStateColor(isPublic, context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.darkHeader.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  roomIcon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        stateIcon,
                        size: 14,
                        color: stateColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        stateLabel,
                        style: TextStyle(
                          color: stateColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: AppColors.textSecondary(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}