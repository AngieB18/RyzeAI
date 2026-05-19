import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:ryzeai/presentation/widgets/index.dart';

export 'publications_empty_state.dart';

class PublicationsHeader extends StatelessWidget {
  final S strings;

  const PublicationsHeader({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return SimpleHeader(
      title: 'Publicaciones',
    );
  }
}

class PublicationCard extends StatelessWidget {
  final Map<String, dynamic> publication;
  final S strings;
  final List<Map<String, dynamic>> rooms;

  const PublicationCard({
    super.key,
    required this.publication,
    required this.strings,
    required this.rooms,
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

  String _getUserDisplayName() {
    try {
      final users = publication['users'];
      if (users is Map) {
        final firstName = users['first_name'] ?? '';
        final lastName = users['last_name'] ?? '';
        if (firstName.isNotEmpty || lastName.isNotEmpty) {
          return '$firstName $lastName'.trim();
        }
        return users['email'] ?? 'Usuario';
      }
    } catch (e) {
      debugPrint('Error getting user name: $e');
    }
    return 'Usuario';
  }

  String _getUserAvatar() {
    try {
      final users = publication['users'];
      if (users is Map) {
        return users['avatar'] ?? '';
      }
    } catch (e) {
      debugPrint('Error getting user avatar: $e');
    }
    return '';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String projectName = publication['name_projects'] ?? strings.projects_untitled;
    final String createdAt = publication['created_at'] ?? '';
    final String roomId = publication['id_type_room']?.toString() ?? '';
    final String userName = _getUserDisplayName();
    final String userAvatar = _getUserAvatar();
    final String formattedDate = _formatDate(createdAt);
    final roomIcon = _getRoomIcon(roomId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del usuario
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar del usuario
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.darkHeader.withOpacity(0.6),
                  ),
                  child: userAvatar.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            userAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                userName.isNotEmpty ? userName[0] : 'U',
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            userName.isNotEmpty ? userName[0] : 'U',
                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Nombre del usuario y fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Contenido de la publicación
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Emoji del tipo de habitación
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.darkHeader.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      roomIcon,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Nombre del proyecto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Público',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
