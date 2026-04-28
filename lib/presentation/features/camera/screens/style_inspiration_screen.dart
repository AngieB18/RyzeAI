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
      return value[_language]?.toString() ??
          value['es']?.toString() ??
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

      final results = await Future.wait([
        TypeRoomService.getTypeRooms(),
        StyleService.getStyles(),
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
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: AppColors.textPrimary(context)),
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
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _rooms.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final room = _rooms[i];
                          final roomId = room['id'].toString();
                          final selected = _selectedRoomId == roomId;

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedRoomId = roomId);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surface(context),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.inputBorder(context),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    room['icon_room']?.toString() ?? '🏠',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    _text(room['name_type_room']),
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : AppColors.textPrimary(context),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Elige el estilo',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 155,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _styles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final style = _styles[i];
                          final styleId = style['id'].toString();
                          final selected = _selectedStyleId == styleId;

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedStyleId = styleId);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      color: AppColors.surface(context),
                                      child: Center(
                                        child: Text(
                                          style['icon']?.toString() ?? '✨',
                                          style: const TextStyle(fontSize: 40),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.75),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 9,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        _text(style['name']),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    SectionHeader(
                      title: 'Elige la paleta de colores',
                      badge: 'Requerido',
                      badgeColor: const Color(0xFF7B1A1A),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 95,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _palettes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final palette = _palettes[i];
                          final paletteId = palette['id'].toString();
                          final selected = _selectedPaletteId == paletteId;
                          final colors = _parseColors(
                            palette['colors_palette'],
                          );

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedPaletteId = paletteId);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 158,
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: AppColors.surface(context),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: colors
                                        .take(4)
                                        .map(
                                          (c) => Container(
                                            width: 22,
                                            height: 22,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: c,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white24,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    _text(palette['name_palette']),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textPrimary(context),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                    SizedBox(
                      height: 105,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _features.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final feature = _features[i];
                          final featureId = feature['id'].toString();
                          final selected =
                              _selectedFeatures.contains(featureId);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selected) {
                                  _selectedFeatures.remove(featureId);
                                } else if (_selectedFeatures.length < 5) {
                                  _selectedFeatures.add(featureId);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.surface(context),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _featureIcon(
                                      feature['icon_feature']?.toString(),
                                    ),
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _text(feature['name_feature']),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textPrimary(context),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.inputBorder(context),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      selected ? Icons.check : Icons.add,
                                      size: 13,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      style: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText:
                            'Ej: Pon un escritorio de madera, plantas y luz cálida...',
                        hintStyle: TextStyle(
                          color:
                              AppColors.textSecondary(context).withOpacity(0.5),
                          fontSize: 13,
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

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _canGenerate ? _generateIdea : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor:
                              AppColors.primary.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '✨ Generar diseño',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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