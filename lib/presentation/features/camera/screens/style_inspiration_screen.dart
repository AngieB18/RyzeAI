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
import 'package:ryzeai/presentation/widgets/colors/index.dart';
import 'package:ryzeai/presentation/widgets/global/global_loader.dart';
import 'package:ryzeai/generated/l10n.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class StyleInspirationScreen extends StatefulWidget {
  final File image;

  const StyleInspirationScreen({super.key, required this.image});

  @override
  State<StyleInspirationScreen> createState() => _StyleInspirationScreenState();
}

class _StyleInspirationScreenState extends State<StyleInspirationScreen> {
  final _supabase = Supabase.instance.client;

  // ── Selecciones ──────────────────────────────────────────────────────────────
  String? _selectedRoomId;
  String? _selectedStyleId;
  String? _selectedPaletteId;
  String? _cameraOption;
  final Set<String> _selectedFeatures = {};

  // ── Controladores ────────────────────────────────────────────────────────────
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ── Claves globales para scroll a campo con error ────────────────────────────
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _roomKey = GlobalKey();
  final GlobalKey _styleKey = GlobalKey();
  final GlobalKey _paletteKey = GlobalKey();
  final GlobalKey _promptKey = GlobalKey();

  // ── Estado ───────────────────────────────────────────────────────────────────
  bool _isLoading = true;
  bool _isGenerating = false;

  /// Se activa cuando el usuario toca "Generar" por primera vez.
  /// Solo a partir de ese momento se muestran los mensajes de error.
  bool _submitted = false;

  String _language = 'es';

  List<Map<String, dynamic>> _rooms = [];
  List<Map<String, dynamic>> _styles = [];
  List<Map<String, dynamic>> _palettes = [];
  List<Map<String, dynamic>> _features = [];

  // ── Voz a texto ──────────────────────────────────────────────────────────────
  late SpeechToText _speech;
  bool _isListening = false;
  String _listeningText = '';

  // ── Getters ──────────────────────────────────────────────────────────────────
  bool get _canGenerate =>
      !_isLoading &&
      !_isGenerating &&
      _selectedRoomId != null &&
      _selectedStyleId != null &&
      _selectedPaletteId != null &&
      _nameController.text.trim().isNotEmpty &&
      _promptController.text.trim().isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _nameController.addListener(() => setState(() {}));
    _promptController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // VOZ A TEXTO
  // ─────────────────────────────────────────────────────────────────────────────

  void _startListening() async {
    final strings = S.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final listeningText = strings.listening;
    final speechUnavailableText = strings.speechUnavailable;

    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(strings.microphonePermissionDenied)),
        );
      }
      debugPrint(strings.microphonePermissionDenied);
      return;
    }

    final localeId = _language == 'es' ? 'es_ES' : 'en_US';
    bool available = await _speech.initialize(
      onStatus: (status) {
        debugPrint('${strings.speechRecognitionStatus}: $status');
        if (status == 'done' || status == 'notListening') {
          _stopListening();
        }
      },
      onError: (error) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(
                '${strings.speechRecognitionError}: ${error.errorMsg}',
              ),
            ),
          );
        }
        debugPrint('${strings.speechRecognitionError}: $error');
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
        _listeningText = listeningText;
      });
      _animateListening();

      _speech.listen(
        localeId: localeId,
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 4),
        onResult: (result) {
          if (result.finalResult) {
            setState(() {
              String newText =
                  ('${_promptController.text} ${result.recognizedWords}')
                      .trim();
              if (newText.length > 250) {
                newText = newText.substring(0, 250);
              }
              _promptController.text = newText;
            });
          }
        },
      );
    } else {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(speechUnavailableText)),
        );
      }
      debugPrint(speechUnavailableText);
    }
  }

  void _stopListening() {
    _speech.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  void _animateListening() {
    final strings = S.of(context);
    int dots = 0;
    Future.doWhile(() async {
      if (!_isListening) return false;
      await Future.delayed(const Duration(milliseconds: 500));
      dots = (dots + 1) % 4;
      final listeningBase = strings.listening;
      if (!mounted) return false;
      setState(() => _listeningText = '$listeningBase${'.' * dots}');
      return true;
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

  String _text(dynamic value) {
    if (value is Map) {
      final selectedText = value[_language];
      if (selectedText != null && selectedText.toString().trim().isNotEmpty) {
        return selectedText.toString();
      }
      return value['es']?.toString() ?? value['en']?.toString() ?? '';
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

  String _featureIcon(String? icon) {
    if (icon == null || icon.isEmpty) return '✨';
    return icon;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // VALIDACIÓN
  // ─────────────────────────────────────────────────────────────────────────────

  /// Devuelve un widget de error rojo si [_submitted] es true y [isValid] es false.
  /// Si todo está bien, devuelve [SizedBox.shrink()].
  Widget _fieldError(String message, {required bool isValid}) {
    if (!_submitted || isValid) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 14),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Hace scroll hasta el primer campo con error.
  void _scrollToFirstError() {
    GlobalKey? firstErrorKey;

    if (_nameController.text.trim().isEmpty) {
      firstErrorKey = _nameKey;
    } else if (_selectedRoomId == null) {
      firstErrorKey = _roomKey;
    } else if (_selectedStyleId == null) {
      firstErrorKey = _styleKey;
    } else if (_selectedPaletteId == null) {
      firstErrorKey = _paletteKey;
    } else if (_promptController.text.trim().isEmpty) {
      firstErrorKey = _promptKey;
    }

    if (firstErrorKey == null) return;

    final context = firstErrorKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CARGA DE DATOS
  // ─────────────────────────────────────────────────────────────────────────────

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
      debugPrint('Error loading user language: $e');
    }
  }

  Future<void> _loadData() async {
    final strings = S.of(context);
    GlobalLoader.show(context);

    try {
      await _loadUserLanguage();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception(strings.userNotAuthenticated);

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
      debugPrint('Error loading inspiration data: $e');
      if (mounted) setState(() => _isLoading = false);
    } finally {
      if (mounted) GlobalLoader.hide(context);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GENERAR
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _generateIdea() async {
    final strings = S.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // 1. Activa la validación visual en todos los campos.
    setState(() => _submitted = true);

    // 2. Si hay campos incompletos, hace scroll al primero y sale.
    if (!_canGenerate) {
      _scrollToFirstError();
      return;
    }

    setState(() => _isGenerating = true);
    GlobalLoader.show(context);

    try {
      final originalImageUrl = await ProjectsService.uploadOriginalImage(
        widget.image,
      );

      if (originalImageUrl == null) {
        throw Exception(strings.errorUploadingOriginalImage);
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

      if (project == null) throw Exception(strings.errorSavingProject);

      if (!mounted) return;

      GlobalLoader.hide(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResultScreen(resultImageUrl: generatedImageUrl),
        ),
      );
    } catch (e) {
      debugPrint('${strings.errorGeneratingIdea}: $e');
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(strings.generateProjectError)),
        );
      }
    } finally {
      if (mounted) {
        GlobalLoader.hide(context);
        setState(() => _isGenerating = false);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            const StyleInspirationHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Imagen capturada ───────────────────────────────────────
                    CapturedImagePreview(image: widget.image),
                    const SizedBox(height: 28),

                    // ── Nombre del proyecto ────────────────────────────────────
                    SectionHeader(
                      key: _nameKey,
                      title: strings.projectNameTitle,
                      badge: strings.required,
                      badgeColor: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    NameProjectInput(
                      controller: _nameController,
                      textStyle: TextStyle(
                        color: AppColors.textPrimary(context),
                      ),
                      decoration: InputDecoration(
                        hintText: strings.projectNameHint,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary(
                            context,
                          ).withValues(alpha: 0.4 * 255),
                        ),
                        filled: true,
                        fillColor: AppColors.surface(context),
                        // Borde rojo si _submitted y campo vacío
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                _submitted &&
                                    _nameController.text.trim().isEmpty
                                ? AppColors.error
                                : AppColors.inputBorder(context),
                            width:
                                _submitted &&
                                    _nameController.text.trim().isEmpty
                                ? 1.5
                                : 1.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.inputBorder(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                _submitted &&
                                    _nameController.text.trim().isEmpty
                                ? AppColors.error
                                : AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    _fieldError(
                      strings.projectNameRequiredError,
                      isValid: _nameController.text.trim().isNotEmpty,
                    ),

                    const SizedBox(height: 28),

                    // ── Tipo de habitación ─────────────────────────────────────
                    SectionHeader(
                      key: _roomKey,
                      title: strings.roomTypeTitle,
                      badge: strings.required,
                      badgeColor: AppColors.error,
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
                    _fieldError(
                      strings.roomTypeRequiredError,
                      isValid: _selectedRoomId != null,
                    ),

                    const SizedBox(height: 28),

                    // ── Estilo ─────────────────────────────────────────────────
                    SectionHeader(
                      key: _styleKey,
                      title: strings.styleTitle,
                      badge: strings.required,
                      badgeColor: AppColors.error,
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
                    _fieldError(
                      strings.styleRequiredError,
                      isValid: _selectedStyleId != null,
                    ),

                    const SizedBox(height: 28),

                    // ── Paleta de colores ──────────────────────────────────────
                    SectionHeader(
                      key: _paletteKey,
                      title: strings.colorPaletteTitle,
                      badge: strings.required,
                      badgeColor: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    ColorPaletteSelector(
                      palettes: _palettes
                          .map(
                            (palette) => {
                              'key': palette['id'].toString(),
                              'colors': _parseColors(palette['colors_palette']),
                            },
                          )
                          .toList(),
                      selectedPalette: _selectedPaletteId,
                      onPaletteSelected: (paletteId) {
                        setState(() => _selectedPaletteId = paletteId);
                      },
                      getPaletteLabel: (key) {
                        final palette = _palettes.firstWhere(
                          (item) => item['id'].toString() == key,
                          orElse: () => {},
                        );
                        return _text(palette['name_palette']);
                      },
                    ),
                    _fieldError(
                      strings.colorPaletteRequiredError,
                      isValid: _selectedPaletteId != null,
                    ),

                    const SizedBox(height: 28),

                    // ── Muebles y objetos (opcional) ───────────────────────────
                    SectionHeader(
                      title: strings.addFurnitureTitle,
                      badge: strings.optional,
                      badgeColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.addFurnitureSubtitle,
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

                    // ── Prompt ─────────────────────────────────────────────────
                    SectionHeader(
                      key: _promptKey,
                      title: strings.promptTitle,
                      badge: strings.required,
                      badgeColor: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    PromptInput(
                      controller: _promptController,
                      maxLength: 250,
                      textStyle: TextStyle(
                        color: AppColors.textPrimary(context),
                      ),
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(
                          context,
                        ).withValues(alpha: 0.5 * 255),
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: _isListening
                            ? _listeningText
                            : strings.promptHint,
                        filled: true,
                        fillColor: AppColors.surface(context),
                        // Borde rojo si _submitted y prompt vacío
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                _submitted &&
                                    _promptController.text.trim().isEmpty
                                ? AppColors.error
                                : AppColors.inputBorder(context),
                            width:
                                _submitted &&
                                    _promptController.text.trim().isEmpty
                                ? 1.5
                                : 1.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.inputBorder(context),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                _submitted &&
                                    _promptController.text.trim().isEmpty
                                ? AppColors.error
                                : AppColors.primary,
                            width: 2,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _isListening ? _stopListening() : _startListening();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isListening
                                  ? AppColors.error.withValues(alpha: 0.2 * 255)
                                  : Colors.transparent,
                            ),
                            child: Icon(
                              Icons.mic,
                              size: _isListening ? 26 : 22,
                              color: _isListening
                                  ? AppColors.error
                                  : AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _fieldError(
                      strings.promptRequiredError,
                      isValid: _promptController.text.trim().isNotEmpty,
                    ),

                    const SizedBox(height: 28),

                    // ── Botón generar ──────────────────────────────────────────
                    GenerateButton(
                      isEnabled: !_isLoading && !_isGenerating,
                      onPressed: _generateIdea,
                      primaryColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: 0.35 * 255,
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
