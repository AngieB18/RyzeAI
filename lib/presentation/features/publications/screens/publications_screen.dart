import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/styles/style_service.dart';
import '../../../../generated/l10n.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';
import '../screens/publications_detail_screen.dart';

class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  final _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _publicationsFuture;

  List<Map<String, dynamic>> _styles = [];
  Set<String> _likedIds = {};
  bool _showingFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadStyles();
    _loadLikes();
    _publicationsFuture = _fetchPublicPublications();
  }

  Future<void> _loadStyles() async {
    try {
      final styles = await StyleService.getStyles();
      if (mounted) setState(() => _styles = styles);
    } catch (e) {
      debugPrint('Error loading styles: $e');
    }
  }

  Future<void> _loadLikes() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId == null) return;
      final response = await _supabase
          .from('publication_likes')
          .select('project_id')
          .eq('user_id', currentUserId);
      if (mounted) {
        setState(() {
          _likedIds = {for (final row in response) row['project_id'].toString()};
        });
      }
    } catch (e) {
      debugPrint('Error loading likes: $e');
    }
  }

  Future<void> _toggleLike(String projectId) async {
    final currentUserId = _supabase.auth.currentUser?.id;
    if (currentUserId == null) return;
    final isLiked = _likedIds.contains(projectId);
    setState(() {
      if (isLiked) {
        _likedIds.remove(projectId);
      } else {
        _likedIds.add(projectId);
      }
    });
    try {
      if (isLiked) {
        await _supabase
            .from('publication_likes')
            .delete()
            .eq('user_id', currentUserId)
            .eq('project_id', projectId);
      } else {
        await _supabase.from('publication_likes').insert({
          'user_id': currentUserId,
          'project_id': projectId,
        });
      }
    } catch (e) {
      setState(() {
        if (isLiked) {
          _likedIds.add(projectId);
        } else {
          _likedIds.remove(projectId);
        }
      });
      debugPrint('Error toggling like: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPublicPublications() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;
      final query = _supabase
          .from('projects')
          .select('''
            *,
            users!user_id (
              first_name,
              last_name,
              photo_url
            )
          ''')
          .eq('public_state', true);
      final filteredQuery = currentUserId != null
          ? query.neq('user_id', currentUserId)
          : query;
      final response = await filteredQuery.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching public publications: $e');
      return [];
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _text(dynamic value) {
    if (value is Map) {
      final es = value['es']?.toString().trim();
      if (es != null && es.isNotEmpty) return es;
      final en = value['en']?.toString().trim();
      if (en != null && en.isNotEmpty) return en;
      return '';
    }
    return value?.toString().trim() ?? '';
  }

  String _styleLabel(dynamic stylesRaw) {
    List<String> ids = [];
    if (stylesRaw is List) {
      ids = stylesRaw.map((e) => e.toString()).toList();
    } else if (stylesRaw is String && stylesRaw.isNotEmpty) {
      ids = [stylesRaw];
    }
    if (ids.isEmpty) return '';
    final style = _styles.firstWhere(
      (s) => s['id']?.toString() == ids.first,
      orElse: () => {},
    );
    return style.isNotEmpty ? _text(style['name']) : '';
  }

  String _styleIcon(dynamic stylesRaw) {
    List<String> ids = [];
    if (stylesRaw is List) {
      ids = stylesRaw.map((e) => e.toString()).toList();
    } else if (stylesRaw is String && stylesRaw.isNotEmpty) {
      ids = [stylesRaw];
    }
    if (ids.isEmpty) return AppEmojis.defaultStyle;
    final style = _styles.firstWhere(
      (s) => s['id']?.toString() == ids.first,
      orElse: () => {},
    );
    if (style.isNotEmpty) {
      final icon = style['icon']?.toString();
      if (icon != null && icon.isNotEmpty) return icon;
    }
    return AppEmojis.defaultStyle;
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return '';
    try {
      final date = dateValue is DateTime
          ? dateValue
          : DateTime.parse(dateValue.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header + filtro ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    strings.publications_title,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Filtro favoritos — toggle inline, sin navegar a otra pantalla
                GestureDetector(
                  onTap: () {
                    setState(() => _showingFavorites = !_showingFavorites);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _showingFavorites
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppEmojis.favoriteActive,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          strings.publications_filter_favorites,
                          style: TextStyle(
                            color: _showingFavorites
                                ? Colors.white
                                : AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _publicationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(strings.projects_error_generic));
                }

                final all = snapshot.data ?? [];
                final publications = _showingFavorites
                    ? all.where((p) => _likedIds.contains(p['id']?.toString())).toList()
                    : all;

                if (publications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _showingFavorites
                              ? AppEmojis.emptyFavorites
                              : AppEmojis.defaultRoom,
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _showingFavorites
                              ? strings.publications_empty_favorites
                              : strings.publications_empty_all,
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: publications.length,
                  itemBuilder: (ctx, i) {
                    final pub = publications[i];
                    final projectId = pub['id']?.toString() ?? '';
                    final isLiked = _likedIds.contains(projectId);
                    return _PublicationCard(
                      publication: pub,
                      styleLabel: _styleLabel(pub['styles']),
                      styleIcon: _styleIcon(pub['styles']),
                      formattedDate: _formatDate(pub['created_at']),
                      isLiked: isLiked,
                      onLike: () => _toggleLike(projectId),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PublicationsDetailScreen(project: pub),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PublicationCard extends StatelessWidget {
  final Map<String, dynamic> publication;
  final String styleLabel;
  final String styleIcon;
  final String formattedDate;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onTap;

  const _PublicationCard({
    required this.publication,
    required this.styleLabel,
    required this.styleIcon,
    required this.formattedDate,
    required this.isLiked,
    required this.onLike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final imageUrl = (publication['generated_image_url'] ??
            publication['original_image_url'])
        ?.toString();

    final user = publication['users'] as Map<String, dynamic>?;
    final firstName = user?['first_name']?.toString() ?? '';
    final lastName = user?['last_name']?.toString() ?? '';
    final authorName = '$firstName $lastName'.trim();
    final photoUrl = user?['photo_url']?.toString();
    final projectName = publication['name_projects']?.toString()
        ?? strings.projects_untitled;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen con botón de like encima ───────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 200,
                              color: AppColors.darkHeader.withValues(alpha: 0.1),
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            color: AppColors.darkHeader.withValues(alpha: 0.1),
                            child: const Icon(Icons.broken_image_outlined,
                                size: 40, color: Colors.grey),
                          ),
                        )
                      : Container(
                          height: 200,
                          color: AppColors.darkHeader.withValues(alpha: 0.1),
                          child: const Icon(Icons.image_not_supported_outlined,
                              size: 40, color: Colors.grey),
                        ),
                ),

                // ── Botón corazón: fondo siempre oscuro, solo el emoji cambia ──
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onLike,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        isLiked ? AppEmojis.favoriteActive : AppEmojis.favoriteInactive,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Nombre del proyecto ─────────────────────────────
                  Text(
                    projectName,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  // ── Autor + fecha ────────────────────────────────────
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.darkHeader.withValues(alpha: 0.15),
                        backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: (photoUrl == null || photoUrl.isEmpty)
                            ? Icon(Icons.person,
                                size: 16, color: AppColors.textSecondary(context))
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authorName.isNotEmpty
                              ? authorName
                              : strings.publications_unknown_author,
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (formattedDate.isNotEmpty)
                        Row(
                          children: [
                            Text(AppEmojis.createdAt,
                                style: const TextStyle(fontSize: 12)),
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

                  // ── Estilo ───────────────────────────────────────────
                  if (styleLabel.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$styleIcon  $styleLabel',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}