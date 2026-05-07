import 'dart:io';

import '../entities/style_inspiration_entities.dart';
import '../repositories/style_inspiration_repository.dart';

class GenerateStyleProjectUseCase {
  final StyleInspirationRepository repository;

  GenerateStyleProjectUseCase(this.repository);

  Future<Project> execute({
    required File image,
    required StyleProjectParams params,
  }) async {
    final originalImageUrl = await repository.uploadOriginalImage(image);
    if (originalImageUrl == null || originalImageUrl.isEmpty) {
      throw Exception('No se pudo subir la imagen original.');
    }

    final finalParams = StyleProjectParams(
      name: params.name,
      roomId: params.roomId,
      styleId: params.styleId,
      paletteId: params.paletteId,
      featureIds: params.featureIds,
      prompt: params.prompt,
      cameraOption: params.cameraOption,
      originalImageUrl: originalImageUrl,
      generatedImageUrl: params.generatedImageUrl,
    );

    final project = await repository.createProject(finalParams);
    if (project == null) {
      throw Exception('No se pudo crear el proyecto.');
    }
    return project;
  }
}
