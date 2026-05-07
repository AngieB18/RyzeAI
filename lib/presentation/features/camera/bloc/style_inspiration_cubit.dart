import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../../domain/camera/entities/style_inspiration_entities.dart';
import '../../../../domain/camera/usecases/get_style_inspiration_data_usecase.dart';
import '../../../../domain/camera/usecases/generate_style_project_usecase.dart';
import 'style_inspiration_state.dart';

class StyleInspirationCubit extends Cubit<StyleInspirationState> {
  final GetStyleInspirationDataUseCase _getDataUseCase;
  final GenerateStyleProjectUseCase _generateProjectUseCase;

  StyleInspirationCubit({
    required GetStyleInspirationDataUseCase getDataUseCase,
    required GenerateStyleProjectUseCase generateProjectUseCase,
  }) : _getDataUseCase = getDataUseCase,
       _generateProjectUseCase = generateProjectUseCase,
       super(StyleInspirationState.initial());

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: StyleInspirationStatus.loading));
    try {
      final data = await _getDataUseCase.execute();
      emit(
        state.copyWith(
          status: StyleInspirationStatus.loaded,
          language: data.language,
          rooms: data.rooms,
          styles: data.styles,
          palettes: data.palettes,
          features: data.features,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StyleInspirationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void updateProjectName(String value) {
    emit(state.copyWith(projectName: value, errorMessage: null));
  }

  void updatePrompt(String value) {
    emit(state.copyWith(prompt: value, errorMessage: null));
  }

  void selectRoom(String roomId) {
    emit(state.copyWith(selectedRoomId: roomId, errorMessage: null));
  }

  void selectStyle(String styleId) {
    emit(state.copyWith(selectedStyleId: styleId, errorMessage: null));
  }

  void selectPalette(String paletteId) {
    emit(state.copyWith(selectedPaletteId: paletteId, errorMessage: null));
  }

  void toggleFeature(String featureId) {
    final updatedFeatures = Set<String>.from(state.selectedFeatureIds);
    if (updatedFeatures.contains(featureId)) {
      updatedFeatures.remove(featureId);
    } else if (updatedFeatures.length < 5) {
      updatedFeatures.add(featureId);
    }
    emit(
      state.copyWith(selectedFeatureIds: updatedFeatures, errorMessage: null),
    );
  }

  void setCameraOption(String option) {
    emit(state.copyWith(cameraOption: option, errorMessage: null));
  }

  void setSubmitted() {
    emit(state.copyWith(submitted: true, errorMessage: null));
  }

  void setListening(bool isListening, {String listeningText = ''}) {
    emit(
      state.copyWith(isListening: isListening, listeningText: listeningText),
    );
  }

  Future<void> generateProject({
    required File image,
    required String generatedImageUrl,
  }) async {
    setSubmitted();
    if (!state.canGenerate) {
      emit(state.copyWith(status: StyleInspirationStatus.validationError));
      return;
    }

    emit(
      state.copyWith(
        status: StyleInspirationStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      final params = StyleProjectParams(
        name: state.projectName.trim(),
        roomId: state.selectedRoomId!,
        styleId: state.selectedStyleId!,
        paletteId: state.selectedPaletteId!,
        featureIds: state.selectedFeatureIds.toList(growable: false),
        prompt: state.prompt.trim(),
        cameraOption: state.cameraOption,
        originalImageUrl: '',
        generatedImageUrl: generatedImageUrl,
      );
      final project = await _generateProjectUseCase.execute(
        image: image,
        params: params,
      );
      emit(
        state.copyWith(
          status: StyleInspirationStatus.success,
          createdProject: project,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StyleInspirationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
