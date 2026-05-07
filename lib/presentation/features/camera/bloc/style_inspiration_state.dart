import 'package:equatable/equatable.dart';

import '../../../../domain/camera/entities/style_inspiration_entities.dart';

enum StyleInspirationStatus {
  initial,
  loading,
  loaded,
  validationError,
  submitting,
  success,
  failure,
}

class StyleInspirationState extends Equatable {
  final StyleInspirationStatus status;
  final String language;
  final List<TypeRoom> rooms;
  final List<StyleModel> styles;
  final List<PaletteModel> palettes;
  final List<FeatureModel> features;
  final String? selectedRoomId;
  final String? selectedStyleId;
  final String? selectedPaletteId;
  final Set<String> selectedFeatureIds;
  final String? cameraOption;
  final String projectName;
  final String prompt;
  final bool submitted;
  final bool isListening;
  final String listeningText;
  final String? errorMessage;
  final Project? createdProject;

  const StyleInspirationState({
    required this.status,
    required this.language,
    required this.rooms,
    required this.styles,
    required this.palettes,
    required this.features,
    this.selectedRoomId,
    this.selectedStyleId,
    this.selectedPaletteId,
    required this.selectedFeatureIds,
    this.cameraOption,
    required this.projectName,
    required this.prompt,
    required this.submitted,
    required this.isListening,
    required this.listeningText,
    this.errorMessage,
    this.createdProject,
  });

  factory StyleInspirationState.initial() {
    return const StyleInspirationState(
      status: StyleInspirationStatus.initial,
      language: 'es',
      rooms: [],
      styles: [],
      palettes: [],
      features: [],
      selectedFeatureIds: {},
      projectName: '',
      prompt: '',
      submitted: false,
      isListening: false,
      listeningText: '',
    );
  }

  bool get isProjectNameValid => projectName.trim().isNotEmpty;
  bool get isRoomSelected => selectedRoomId != null;
  bool get isStyleSelected => selectedStyleId != null;
  bool get isPaletteSelected => selectedPaletteId != null;
  bool get isPromptValid => prompt.trim().isNotEmpty;
  bool get canGenerate {
    return status != StyleInspirationStatus.loading &&
        status != StyleInspirationStatus.submitting &&
        isProjectNameValid &&
        isRoomSelected &&
        isStyleSelected &&
        isPaletteSelected &&
        isPromptValid;
  }

  StyleInspirationState copyWith({
    StyleInspirationStatus? status,
    String? language,
    List<TypeRoom>? rooms,
    List<StyleModel>? styles,
    List<PaletteModel>? palettes,
    List<FeatureModel>? features,
    String? selectedRoomId,
    String? selectedStyleId,
    String? selectedPaletteId,
    Set<String>? selectedFeatureIds,
    String? cameraOption,
    String? projectName,
    String? prompt,
    bool? submitted,
    bool? isListening,
    String? listeningText,
    String? errorMessage,
    Project? createdProject,
  }) {
    return StyleInspirationState(
      status: status ?? this.status,
      language: language ?? this.language,
      rooms: rooms ?? this.rooms,
      styles: styles ?? this.styles,
      palettes: palettes ?? this.palettes,
      features: features ?? this.features,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      selectedPaletteId: selectedPaletteId ?? this.selectedPaletteId,
      selectedFeatureIds: selectedFeatureIds ?? this.selectedFeatureIds,
      cameraOption: cameraOption ?? this.cameraOption,
      projectName: projectName ?? this.projectName,
      prompt: prompt ?? this.prompt,
      submitted: submitted ?? this.submitted,
      isListening: isListening ?? this.isListening,
      listeningText: listeningText ?? this.listeningText,
      errorMessage: errorMessage,
      createdProject: createdProject ?? this.createdProject,
    );
  }

  @override
  List<Object?> get props => [
    status,
    language,
    rooms,
    styles,
    palettes,
    features,
    selectedRoomId,
    selectedStyleId,
    selectedPaletteId,
    selectedFeatureIds,
    cameraOption,
    projectName,
    prompt,
    submitted,
    isListening,
    listeningText,
    errorMessage,
    createdProject,
  ];
}
