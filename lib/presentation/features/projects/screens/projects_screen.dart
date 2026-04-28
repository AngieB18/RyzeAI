import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/features/camera/screens/style_inspiration_screen.dart';
import '../widgets/widgets_projects.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _supabase = Supabase.instance.client;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        final imageFile = File(image.path);
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StyleInspirationScreen(image: imageFile),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

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

  Future<void> _toggleFavorite(String projectId, bool currentStatus) async {
    try {
      await _supabase
          .from('projects')
          .update({'is_favorite': !currentStatus})
          .eq('id', projectId);

      setState(() {});
    } catch (e) {
      debugPrint('Error updating favorite: $e');
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
          ProjectsHeader(strings: strings),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchProjects(),
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
                  return ProjectsEmptyState(
                    onCameraTap: () => _pickImage(ImageSource.camera),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: projects.length,
                  itemBuilder: (ctx, i) {
                    final project = projects[i];
                    return ProjectItem(
                      project: project,
                      strings: strings,
                      getStatusColor: _getStatusColor,
                      getStatusLabel: _getStatusLabel,
                      onToggleFavorite: _toggleFavorite,
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