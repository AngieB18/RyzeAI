// style_inspiration_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/core/services/feature_ser/feature_service.dart';
import 'package:ryzeai/core/services/palette/palette_servicio.dart';
import 'package:ryzeai/core/services/projects/projects_service.dart';
import 'package:ryzeai/core/services/styles/style_service.dart';
import 'package:ryzeai/core/services/type_room/type_room_service.dart';
import 'package:ryzeai/presentation/features/camera/screens/result_screen.dart';
import 'package:ryzeai/presentation/features/camera/widgets/widgets_style_inspiration_screen.dart';
import 'package:ryzeai/presentation/widgets/global/global_loader.dart';
import 'package:flutter/services.dart';

class StyleInspirationScreen extends StatefulWidget {
  final File image;

  const StyleInspirationScreen({
    super.key,
    required this.image,
  });

  @override
  State<StyleInspirationScreen> createState() => _StyleInspirationScreenState();
}

class _StyleInspirationScreenState extends State<StyleInspirationScreen> {
  final _supabase = Supabase.instance.client;

  String? _selectedRoomId;
  String? _selectedStyleId;
  String? _selectedPaletteId;
  String? _cameraOption;

  final Set<String> _selectedFeatures = {};

  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = true;
  bool _isGenerating = false;

  String _language = 'es';

  List<Map<String, dynamic>> _rooms = [];
  List<Map<String, dynamic>> _styles = [];
  List<Map<String, dynamic>> _palettes = [];
  List<Map<String, dynamic>> _features = [];

  bool get _canGenerate =>
      !_isLoading &&
      !_isGenerating &&
      _selectedRoomId != null &&
      _selectedStyleId != null &&
      _selectedPaletteId != null &&
      _nameController.text.trim().isNotEmpty &&
      _promptController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() => setState(() {}));
    _promptController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  String _text(dynamic value) {
    if (value is Map) {
      final selectedText = value[_language];

      if (selectedText != null && selectedText.toString().trim().isNotEmpty) {
        return selectedText.toString();
      }

      return value['es']?.toString() ??
          value['en']?.toString() ??
          '';
    }

    return value?.toString() ?? '';
  }

  List<Color> _parseColors(dynamic value) {
    try {
      if (value is List) {
        return value.map<Color>((item) {
          final hex = item.toString().replaceAll('#', '').trim();
          return Color(int.parse('FF$hex', radix: 16));
        }).toList();
      }

      if (value is String) {
        return value
            .split(',')
            .map((e) => e.trim().replaceAll('#', ''))
            .where((e) => e.isNotEmpty)
            .map((hex) => Color(int.parse('FF$hex', radix: 16)))
            .toList();
      }
    } catch (_) {}

    return [];
  }

  Future<void> _loadUserLanguage() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _supabase
          .from('users')
          .select('language')
          .eq('id', userId)
          .maybeSingle();

      final lang = data?['language']?.toString();

      if (lang != null && lang.isNotEmpty) {
        _language = lang;
      }
    } catch (e) {
      print('Error loading user language: $e');
    }
  }

  Future<void> _loadData() async {
    GlobalLoader.show(context);

    try {
      await _loadUserLanguage();

      final userId = _supabase.auth.currentUser?.id;

        if (userId == null) {
          throw Exception('Usuario no autenticado');
        }

        final results = await Future.wait([
          TypeRoomService.getTypeRooms(),
          StyleService.getStylesForUser(userId),
          PaletteService.getPalettes(),
          FeatureService.getFeatures(),
        ]);

      if (!mounted) return;

      setState(() {
        _rooms = results[0];
        _styles = results[1];
        _palettes = results[2];
        _features = results[3];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading inspiration data: $e');

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } finally {
      if (mounted) {
        GlobalLoader.hide(context);
      }
    }
  }

  String _featureIcon(String? icon) {
    if (icon == null || icon.isEmpty) return '✨';
    return icon;
  }

  Future<void> _generateIdea() async {
    if (!_canGenerate) return;

    setState(() => _isGenerating = true);
    GlobalLoader.show(context);

    try {
      final originalImageUrl =
          await ProjectsService.uploadOriginalImage(widget.image);

      if (originalImageUrl == null) {
        throw Exception('No se pudo subir la imagen original');
      }

      const generatedImageUrl =
          'https://i.pinimg.com/originals/ec/76/e8/ec76e84490e61a29f07812ac58fbca43.gif';

      final project = await ProjectsService.createProject(
        nameProjects: _nameController.text.trim(),
        idTypeRoom: _selectedRoomId!,
        styles: [_selectedStyleId!],
        idPalette: _selectedPaletteId!,
        idFeatures: _selectedFeatures.toList(),
        prompts: _promptController.text.trim(),
        originalImageUrl: originalImageUrl,
        generatedImageUrl: generatedImageUrl,
      );

      if (project == null) {
        throw Exception('No se pudo guardar el proyecto');
      }

      if (!mounted) return;

      GlobalLoader.hide(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResultScreen(
            resultImageUrl: generatedImageUrl,
          ),
        ),
      );
    } catch (e) {
      print('Error generating idea: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo generar el proyecto. Intenta de nuevo.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        GlobalLoader.hide(context);
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            const StyleInspirationHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CapturedImagePreview(image: widget.image),
                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Dale un nombre a tu proyecto',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    NameProjectInput(
                      controller: _nameController,
                      textStyle: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText: 'Ej: Mi dormitorio principal...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary(context)
                              .withOpacity(0.4),
                        ),
                        filled: true,
                        fillColor: AppColors.surface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.inputBorder(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Elige el tipo de habitación',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    RoomSelector(
                      rooms: _rooms,
                      selectedRoomId: _selectedRoomId,
                      onRoomSelected: (roomId) {
                        setState(() => _selectedRoomId = roomId);
                      },
                      textTranslator: _text,
                      primaryColor: AppColors.primary,
                      surfaceColor: AppColors.surface(context),
                      inputBorderColor: AppColors.inputBorder(context),
                      textColor: AppColors.textPrimary(context),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Elige el estilo',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    StyleSelector(
                      styles: _styles,
                      selectedStyleId: _selectedStyleId,
                      onStyleSelected: (styleId) {
                        setState(() => _selectedStyleId = styleId);
                      },
                      textTranslator: _text,
                      primaryColor: AppColors.primary,
                      surfaceColor: AppColors.surface(context),
                      textColor: AppColors.textPrimary(context),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Elige la paleta de colores',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    PaletteSelector(
                      palettes: _palettes,
                      selectedPaletteId: _selectedPaletteId,
                      onPaletteSelected: (paletteId) {
                        setState(() => _selectedPaletteId = paletteId);
                      },
                      textTranslator: _text,
                      colorParser: _parseColors,
                      primaryColor: AppColors.primary,
                      surfaceColor: AppColors.surface(context),
                      inputBorderColor: AppColors.inputBorder(context),
                      textColor: AppColors.textPrimary(context),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Añadir muebles y objetos',
                      badge: 'Opcional',
                      badgeColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Elige hasta 5 objetos para sugerir en tu espacio',
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FeatureSelector(
                      features: _features,
                      selectedFeatures: _selectedFeatures,
                      onFeatureToggle: (featureId) {
                        setState(() {
                          if (_selectedFeatures.contains(featureId)) {
                            _selectedFeatures.remove(featureId);
                          } else if (_selectedFeatures.length < 5) {
                            _selectedFeatures.add(featureId);
                          }
                        });
                      },
                      featureIcon: _featureIcon,
                      textTranslator: _text,
                      primaryColor: AppColors.primary,
                      surfaceColor: AppColors.surface(context),
                      inputBorderColor: AppColors.inputBorder(context),
                      textColor: AppColors.textPrimary(context),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Cámara y foto',
                      badge: 'Opcional',
                      badgeColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CameraChip(
                          icon: Icons.home_work_outlined,
                          label: 'Mantener detalles',
                          desc: 'Conserva elementos existentes',
                          selected: _cameraOption == 'details',
                          onTap: () {
                            setState(() => _cameraOption = 'details');
                          },
                        ),
                        CameraChip(
                          icon: Icons.crop_free,
                          label: 'Mismo ángulo',
                          desc: 'Mantiene la perspectiva original',
                          selected: _cameraOption == 'same_angle',
                          onTap: () {
                            setState(() => _cameraOption = 'same_angle');
                          },
                        ),
                        CameraChip(
                          icon: Icons.rotate_90_degrees_cw_outlined,
                          label: 'Cambiar ángulo',
                          desc: 'La IA elige un ángulo mejor',
                          selected: _cameraOption == 'change_angle',
                          onTap: () {
                            setState(() => _cameraOption = 'change_angle');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: '¿Qué quieres cambiar o agregar?',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    PromptInput(
                      controller: _promptController,
                      maxLength: 250,
                      textStyle: TextStyle(color: AppColors.textPrimary(context)),
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(context).withOpacity(0.5),
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ej: Pon un escritorio de madera, plantas y luz cálida...',
                        filled: true,
                        fillColor: AppColors.surface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.inputBorder(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    GenerateButton(
                      isEnabled: _canGenerate,
                      onPressed: _generateIdea,
                      primaryColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.35),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}