import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../widgets/widgets_favorites.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _supabase = Supabase.instance.client;

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

      setState(() {});
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.passwordStrong;
      case 'in progress':
        return AppColors.passwordMedium;
      default:
        return AppColors.darkTextSecondary;
    }
  }

  String _getStatusLabel(String status, S strings) {
    switch (status.toLowerCase()) {
      case 'completed':
        return strings.projects_status_completed;
      case 'in progress':
        return strings.projects_status_in_progress;
      default:
        return strings.projects_status_draft;
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

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (ctx, i) {
                    final project = projects[i];
                    return FavoriteProjectItem(
                      project: project,
                      strings: strings,
                      getStatusColor: _getStatusColor,
                      getStatusLabel: _getStatusLabel,
                      onRemoveFavorite: _removeFavorite,
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