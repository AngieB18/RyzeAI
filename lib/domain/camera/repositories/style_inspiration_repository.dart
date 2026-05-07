import 'dart:io';

import '../entities/style_inspiration_entities.dart';

abstract class StyleInspirationRepository {
  Future<StyleInspirationData> fetchStyleInspirationData();
  Future<String?> uploadOriginalImage(File image);
  Future<Project?> createProject(StyleProjectParams params);
}
