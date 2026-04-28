import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectsService {
  static final _supabase = Supabase.instance.client;

  static const String _bucketName = 'project-images';

  static Future<String?> uploadOriginalImage(File image) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final fileName =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _supabase.storage.from(_bucketName).upload(fileName, image);

      final publicUrl =
          _supabase.storage.from(_bucketName).getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Error uploading original image: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> createProject({
    required String nameProjects,
    required String idTypeRoom,
    required List<String> styles,
    required String idPalette,
    required List<String> idFeatures,
    required String prompts,
    required String originalImageUrl,
    String? generatedImageUrl,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('projects')
          .insert({
            'user_id': user.id,
            'name_projects': nameProjects,
            'id_type_room': idTypeRoom,
            'styles': styles,
            'id_palette': idPalette,
            'id_features': idFeatures,
            'prompts': prompts,
            'original_image_url': originalImageUrl,
            'generated_image_url': generatedImageUrl,
            'is_favorite': false,
            'public_state': false,
          })
          .select()
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('Error creating project: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getProjects() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('projects')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error loading projects: $e');
      return [];
    }
  }

  static Future<bool> updateProject({
    required String projectId,
    String? nameProjects,
    String? generatedImageUrl,
    bool? isFavorite,
    bool? publicState,
  }) async {
    try {
      final data = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (nameProjects != null) data['name_projects'] = nameProjects;
      if (generatedImageUrl != null) {
        data['generated_image_url'] = generatedImageUrl;
      }
      if (isFavorite != null) data['is_favorite'] = isFavorite;
      if (publicState != null) data['public_state'] = publicState;

      await _supabase.from('projects').update(data).eq('id', projectId);

      return true;
    } catch (e) {
      print('Error updating project: $e');
      return false;
    }
  }

  static Future<bool> deleteProject(String projectId) async {
    try {
      await _supabase.from('projects').delete().eq('id', projectId);
      return true;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }
}