import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _supabase = Supabase.instance.client;

  // 1. Consulta solo los proyectos donde is_favorite es true
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

  // 2. Función para quitar de favoritos
  Future<void> _removeFavorite(String projectId) async {
    try {
      await _supabase
          .from('projects')
          .update({'is_favorite': false})
          .eq('id', projectId);
      
      setState(() {}); // Refrescamos la lista
    } catch (e) {
      debugPrint('Error al quitar de favoritos: $e');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed': return AppColors.passwordStrong;
      case 'in progress': return AppColors.passwordMedium;
      default: return AppColors.darkTextSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFavoriteProjects(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final projects = snapshot.data ?? [];

                if (projects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Usamos el emoji desde AppEmojis
                        Text(
                          AppEmojis.getUI('empty_fav'), 
                          style: const TextStyle(fontSize: 50),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Aún no tienes proyectos favoritos',
                          style: TextStyle(color: AppColors.textSecondary(context)),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (ctx, i) {
                    final project = projects[i];
                    return _buildFavoriteProjectCard(ctx, project);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, S l) {
    return SimpleHeader(title: l.favorites);
  }

  Widget _buildFavoriteProjectCard(BuildContext context, Map<String, dynamic> project) {
    final String projectId = project['id'];

    return Stack(
      children: [
        ProjectCard(
          icon: AppEmojis.getRoom(project['room'] ?? ''),
          name: project['name'] ?? 'Sin nombre',
          items: "${(project['styles'] as List?)?.length ?? 0} estilos",
          status: project['status'] ?? 'Draft',
          statusColor: _getStatusColor(project['status'] ?? ''),
        ),
        // Botón de favorito usando emoji de la clase AppEmojis
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: Text(
              AppEmojis.favoriteActive, 
              style: const TextStyle(fontSize: 22),
            ),
            onPressed: () => _removeFavorite(projectId),
          ),
        ),
      ],
    );
  }
}