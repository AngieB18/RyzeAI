import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/services/feature_ser/feature_service.dart';
import 'package:ryzeai/core/services/palette/palette_servicio.dart';
import 'package:ryzeai/core/services/projects/projects_service.dart';
import 'package:ryzeai/core/services/styles/style_service.dart';
import 'package:ryzeai/core/services/type_room/type_room_service.dart';

import '../../../domain/camera/entities/style_inspiration_entities.dart';
import '../../../domain/camera/repositories/style_inspiration_repository.dart';

class StyleInspirationRepositoryImpl implements StyleInspirationRepository {
  final SupabaseClient _supabase;

  StyleInspirationRepositoryImpl({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  @override
  Future<StyleInspirationData> fetchStyleInspirationData() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Usuario no autenticado.');
    }

    final language = await _getUserLanguage(userId);

    final results = await Future.wait([
      TypeRoomService.getTypeRooms(),
      StyleService.getStylesForUser(userId),
      PaletteService.getPalettes(),
      FeatureService.getFeatures(),
    ]);

    final rooms = results[0]
        .map<TypeRoom>((item) => TypeRoom.fromMap(item))
        .toList(growable: false);
    final styles = results[1]
        .map<StyleModel>((item) => StyleModel.fromMap(item))
        .toList(growable: false);
    final palettes = results[2]
        .map<PaletteModel>((item) => PaletteModel.fromMap(item))
        .toList(growable: false);
    final features = results[3]
        .map<FeatureModel>((item) => FeatureModel.fromMap(item))
        .toList(growable: false);

    return StyleInspirationData(
      language: language,
      rooms: rooms,
      styles: styles,
      palettes: palettes,
      features: features,
    );
  }

  @override
  Future<String?> uploadOriginalImage(File image) {
    return ProjectsService.uploadOriginalImage(image);
  }

  @override
  Future<Project?> createProject(StyleProjectParams params) async {
    final project = await ProjectsService.createProject(
      nameProjects: params.name,
      idTypeRoom: params.roomId,
      styles: [params.styleId],
      idPalette: params.paletteId,
      idFeatures: params.featureIds,
      prompts: params.prompt,
      originalImageUrl: params.originalImageUrl,
      generatedImageUrl: params.generatedImageUrl,
    );

    if (project == null) return null;
    return Project.fromMap(project);
  }

  Future<String> _getUserLanguage(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('language')
          .eq('id', userId)
          .maybeSingle();

      return response?['language']?.toString() ?? 'es';
    } catch (_) {
      return 'es';
    }
  }
}
