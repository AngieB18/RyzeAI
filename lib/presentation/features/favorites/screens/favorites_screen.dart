import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/type_room/type_room_service.dart';
import '../../../../generated/l10n.dart';
import '../../projects/screens/project_detail_screen.dart';
import '../widgets/widgets_favorites.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await TypeRoomService.getTypeRooms();
      if (mounted) {
        setState(() {
          _rooms = rooms;
        });
      }
    } catch (e) {
      debugPrint('Error loading rooms: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFavoriteProjects() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('projects')
        .select()
        .eq('user_id', userId)
        .eq('is_favorite', true)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> _removeFavorite(String projectId) async {
    try {
      await _supabase
          .from('projects')
          .update({'is_favorite': false})
          .eq('id', projectId);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FavoritesHeader(strings: strings),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFavoriteProjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(strings.projects_error_generic),
                  );
                }

                final projects = snapshot.data ?? [];

                if (projects.isEmpty) {
                  return FavoritesEmptyState(strings: strings);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: projects.length,
                  itemBuilder: (ctx, i) {
                    final project = projects[i];
                    return FavoriteProjectItem(
                      project: project,
                      strings: strings,
                      rooms: _rooms,
                      onRemoveFavorite: _removeFavorite,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailScreen(project: project),
                          ),
                        );
                      },
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