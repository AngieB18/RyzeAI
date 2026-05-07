import 'dart:io';

class TypeRoom {
  final String id;
  final String name;
  final String icon;

  TypeRoom({required this.id, required this.name, required this.icon});

  factory TypeRoom.fromMap(Map<String, dynamic> map) {
    return TypeRoom(
      id: map['id']?.toString() ?? '',
      name: map['name_type_room']?.toString() ?? '',
      icon: map['icon_room']?.toString() ?? '🏠',
    );
  }
}

class StyleModel {
  final String id;
  final String name;
  final String icon;

  StyleModel({required this.id, required this.name, required this.icon});

  factory StyleModel.fromMap(Map<String, dynamic> map) {
    return StyleModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      icon: map['icon']?.toString() ?? '✨',
    );
  }
}

class PaletteModel {
  final String id;
  final String name;
  final List<String> colors;

  PaletteModel({required this.id, required this.name, required this.colors});

  factory PaletteModel.fromMap(Map<String, dynamic> map) {
    final colorsValue = map['colors_palette'];
    final colors = <String>[];

    if (colorsValue is String) {
      colors.addAll(
        colorsValue
            .split(',')
            .map((value) => value.toString().replaceAll('#', '').trim())
            .where((value) => value.isNotEmpty)
            .map((value) => '#$value'),
      );
    } else if (colorsValue is List) {
      colors.addAll(
        colorsValue
            .map((item) => item?.toString().replaceAll('#', '').trim())
            .where((item) => item != null && item.isNotEmpty)
            .map((item) => '#${item!}'),
      );
    }

    return PaletteModel(
      id: map['id']?.toString() ?? '',
      name: map['name_palette']?.toString() ?? '',
      colors: colors,
    );
  }
}

class FeatureModel {
  final String id;
  final String name;
  final String icon;

  FeatureModel({required this.id, required this.name, required this.icon});

  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    return FeatureModel(
      id: map['id']?.toString() ?? '',
      name: map['name_feature']?.toString() ?? '',
      icon: map['icon_feature']?.toString() ?? '✨',
    );
  }
}

class StyleInspirationData {
  final String language;
  final List<TypeRoom> rooms;
  final List<StyleModel> styles;
  final List<PaletteModel> palettes;
  final List<FeatureModel> features;

  StyleInspirationData({
    required this.language,
    required this.rooms,
    required this.styles,
    required this.palettes,
    required this.features,
  });
}

class StyleProjectParams {
  final String name;
  final String roomId;
  final String styleId;
  final String paletteId;
  final List<String> featureIds;
  final String prompt;
  final String? cameraOption;
  final String originalImageUrl;
  final String generatedImageUrl;

  StyleProjectParams({
    required this.name,
    required this.roomId,
    required this.styleId,
    required this.paletteId,
    required this.featureIds,
    required this.prompt,
    this.cameraOption,
    required this.originalImageUrl,
    required this.generatedImageUrl,
  });
}

class Project {
  final String id;
  final String originalImageUrl;
  final String generatedImageUrl;

  Project({
    required this.id,
    required this.originalImageUrl,
    required this.generatedImageUrl,
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id']?.toString() ?? '',
      originalImageUrl: map['original_image_url']?.toString() ?? '',
      generatedImageUrl: map['generated_image_url']?.toString() ?? '',
    );
  }
}
