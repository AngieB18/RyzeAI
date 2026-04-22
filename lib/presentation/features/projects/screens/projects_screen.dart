import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _supabase = Supabase.instance.client;

  // 1. Función para obtener proyectos (ahora trae is_favorite)
  Future<List<Map<String, dynamic>>> _fetchProjects() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('projects')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return List<Map<String, dynamic>>.from(response);
  }

  // 2. Función para cambiar el estado de favorito en la DB
  Future<void> _toggleFavorite(String projectId, bool currentStatus) async {
    try {
      await _supabase
          .from('projects')
          .update({'is_favorite': !currentStatus})
          .eq('id', projectId);
      
      // Refrescamos la UI
      setState(() {}); 
    } catch (e) {
      debugPrint('Error al actualizar favorito: $e');
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
              // Usamos el future pero recuerda que al hacer setState se vuelve a disparar
              future: _fetchProjects(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final projects = snapshot.data ?? [];

                if (projects.isEmpty) {
                  return const Center(child: Text('No tienes proyectos creados aún.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: projects.length,
                  itemBuilder: (ctx, i) {
                    final project = projects[i];
                    return _buildProjectCard(ctx, project);
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
    return SimpleHeader(
      title: l.projects,
      trailing: GestureDetector(
        onTap: () {
          // Aquí iría la navegación a crear nuevo proyecto
        },
        child: Container(
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
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> project) {
    final bool isFavorite = project['is_favorite'] ?? false;
    final String projectId = project['id'];

    return Stack(
      children: [
        ProjectCard(
          icon: AppEmojis.getRoom(project['room'] ?? ''),
          name: project['name'] ?? 'Untitled',
          items: "${(project['styles'] as List?)?.length ?? 0} estilos", 
          status: project['status'] ?? 'Draft',
          statusColor: _getStatusColor(project['status'] ?? ''),
        ),
        // Posicionamos el corazón arriba a la derecha de la tarjeta
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => _toggleFavorite(projectId, isFavorite),
          ),
        ),
      ],
    );
  }
}