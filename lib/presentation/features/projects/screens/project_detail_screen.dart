import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/feature_ser/feature_service.dart';
import '../../../../core/services/palette/palette_servicio.dart';
import '../../../../core/services/styles/style_service.dart';
import '../../../../core/services/type_room/type_room_service.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/emojis/app_emojis.dart';
import '../widgets/project_detail_widgets.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  final _supabase = Supabase.instance.client;
  bool _isSaving = false;
  bool _isDeleting = false;
  bool _isLoadingMetadata = true;

  // ✅ FIX 1: Copia local mutable del proyecto para que setState funcione correctamente
  late Map<String, dynamic> _project;

  List<Map<String, dynamic>> _rooms = [];
  List<Map<String, dynamic>> _styles = [];
  List<Map<String, dynamic>> _palettes = [];
  List<Map<String, dynamic>> _features = [];

  bool _showingOriginal = false;
  // ✅ Cache buster: cambia cada vez que se regenera la imagen
  int _imageCacheBuster = 0;

  @override
  void initState() {
    super.initState();
    // ✅ FIX 1: Inicializar copia local en initState
    _project = Map<String, dynamic>.from(widget.project);
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    try {
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
        _isLoadingMetadata = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingMetadata = false);
    }
  }

  // ── Helpers de texto / lookup ──────────────────────────────────────────────

  String _text(dynamic value) {
    if (value is Map) {
      final es = value['es']?.toString().trim();
      if (es != null && es.isNotEmpty) return es;
      final en = value['en']?.toString().trim();
      if (en != null && en.isNotEmpty) return en;
      return '';
    }
    return value?.toString().trim() ?? '';
  }

  String _roomName(String? roomId) {
    if (roomId == null) return S.of(context).project_detail_default_room;
    final room = _rooms.firstWhere(
      (item) => item['id']?.toString() == roomId,
      orElse: () => {},
    );
    if (room.isNotEmpty) return _text(room['name_type_room']);
    return S.of(context).project_detail_default_room;
  }

  String _roomIcon(String? roomId) {
    if (roomId == null) return AppEmojis.defaultRoom;
    final room = _rooms.firstWhere(
      (item) => item['id']?.toString() == roomId,
      orElse: () => {},
    );
    if (room.isNotEmpty) {
      final icon = room['icon_room']?.toString();
      if (icon != null && icon.isNotEmpty) return icon;
    }
    return AppEmojis.defaultRoom;
  }

  String _styleLabel(String styleId) {
    final style = _styles.firstWhere(
      (item) => item['id']?.toString() == styleId,
      orElse: () => {},
    );
    if (style.isNotEmpty) return _text(style['name']);
    return styleId;
  }

  String _styleIcon(String styleId) {
    final style = _styles.firstWhere(
      (item) => item['id']?.toString() == styleId,
      orElse: () => {},
    );
    if (style.isNotEmpty) {
      final icon = style['icon']?.toString();
      if (icon != null && icon.isNotEmpty) return icon;
    }
    return AppEmojis.defaultStyle;
  }

  Map<String, dynamic>? _findPalette(String? paletteId) {
    if (paletteId == null) return null;
    final result = _palettes.firstWhere(
      (item) => item['id']?.toString() == paletteId,
      orElse: () => {},
    );
    return result.isNotEmpty ? result : null;
  }

  String _paletteName(String? paletteId) {
    if (paletteId == null) return S.of(context).project_detail_default_palette;
    final palette = _findPalette(paletteId);
    if (palette != null && palette.isNotEmpty) return _text(palette['name_palette']);
    return S.of(context).project_detail_default_palette;
  }

  List<Color> _paletteColors(String? paletteId) {
    final palette = _findPalette(paletteId);
    if (palette == null || palette.isEmpty) return [];
    return _parseColors(palette['colors_palette']);
  }

  String _featureLabel(String featureId) {
    final feature = _features.firstWhere(
      (item) => item['id']?.toString() == featureId,
      orElse: () => {},
    );
    if (feature.isNotEmpty) return _text(feature['name_feature']);
    return S.of(context).project_detail_default_feature;
  }

  String _featureIcon(String featureId) {
    final feature = _features.firstWhere(
      (item) => item['id']?.toString() == featureId,
      orElse: () => {},
    );
    if (feature.isNotEmpty) {
      final icon = feature['icon_feature']?.toString();
      if (icon != null && icon.isNotEmpty) return icon;
    }
    return AppEmojis.defaultFeature;
  }

  List<Color> _parseColors(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().replaceAll('#', '').trim())
          .where((hex) => hex.isNotEmpty)
          .map((hex) => Color(int.parse('FF$hex', radix: 16)))
          .toList();
    }
    if (value is String) {
      return value
          .split(',')
          .map((item) => item.replaceAll('#', '').trim())
          .where((hex) => hex.isNotEmpty)
          .map((hex) => Color(int.parse('FF$hex', radix: 16)))
          .toList();
    }
    return [];
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) return value.map((item) => item.toString()).toList();
    if (value is String && value.isNotEmpty) return [value];
    return [];
  }

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return S.of(context).project_detail_date_unavailable;
    try {
      final date = dateValue is DateTime
          ? dateValue
          : DateTime.parse(dateValue.toString());
      return '${date.day}/${date.month}/${date.year} · '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateValue.toString();
    }
  }

  // ── Acciones principales ───────────────────────────────────────────────────

  Future<void> _togglePublicState() async {
    setState(() => _isSaving = true);
    try {
      final projectId = _project['id'];
      final currentState = _project['public_state'] == true;
      await _supabase
          .from('projects')
          .update({'public_state': !currentState}).eq('id', projectId);
      if (!mounted) return;
      // ✅ FIX 2: Usar _project en lugar de widget.project
      setState(() {
        _project['public_state'] = !currentState;
        _isSaving = false;
      });
      final strings = S.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(currentState
              ? strings.project_detail_now_private
              : strings.project_detail_now_public),
          backgroundColor: currentState
              ? AppColors.passwordWeak
              : AppColors.passwordStrong,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).project_detail_error_update(e.toString())),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  /// Muestra el bottom sheet de edición completo: nombre, prompt, habitación, estilos, paleta y features.
  void _openEditSheet() {
    final strings = S.of(context);

    // ✅ FIX 2: Leer valores desde _project (copia local)
    final nameController = TextEditingController(
      text: _project['name_projects']?.toString() ?? '',
    );
    final promptController = TextEditingController(
      text: _project['prompts']?.toString() ?? '',
    );

    String? selectedRoomId = _project['id_type_room']?.toString();
    String? selectedPaletteId = _project['id_palette']?.toString();
    List<String> selectedStyles = List<String>.from(
      _toStringList(_project['styles']),
    );
    List<String> selectedFeatures = List<String>.from(
      _toStringList(_project['id_features']),
    );

    final formKey = GlobalKey<FormState>();
    bool isSavingEdit = false;
    bool isRegenerating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {

            // ── Guardar + regenerar imagen ─────────────────────────────
            Future<void> saveAndRegenerate() async {
              if (!formKey.currentState!.validate()) return;
              setSheetState(() => isSavingEdit = true);
              try {
                final projectId = _project['id'];
                final newName = nameController.text.trim();
                final newPrompt = promptController.text.trim();
                final now = DateTime.now().toIso8601String();

                // 1. Actualizar todos los campos en Supabase
                await _supabase.from('projects').update({
                  'name_projects': newName,
                  'prompts': newPrompt,
                  'id_type_room': selectedRoomId,
                  'id_palette': selectedPaletteId,
                  'styles': selectedStyles,
                  'id_features': selectedFeatures,
                  'updated_at': now,
                }).eq('id', projectId);

                // 2. Marcar como regenerando e invocar edge function
                setSheetState(() {
                  isSavingEdit = false;
                  isRegenerating = true;
                });

                // Obtener datos de paleta y estilos para construir el body correcto
                final paletteData = _findPalette(selectedPaletteId);
                final paletteColors = paletteData != null
                    ? _parseColors(paletteData['colors_palette'])
                        .map((c) =>
                            '#${c.value.toRadixString(16).substring(2).toUpperCase()}')
                        .toList()
                    : <String>[];
                final paletteName = paletteData != null
                    ? _text(paletteData['name_palette'])
                    : null;

                // Primer estilo seleccionado como string (la función espera un solo estilo)
                final styleLabel = selectedStyles.isNotEmpty
                    ? _styleLabel(selectedStyles.first)
                    : null;

                // roomType como label legible
                final roomTypeLabel = selectedRoomId != null
                    ? _roomName(selectedRoomId)
                    : null;

                // originalImageUrl es obligatorio para la Edge Function
                final originalImageUrl =
                    _project['original_image_url']?.toString();

                debugPrint('🔄 Invocando generate-room-design para proyecto: $projectId');
                debugPrint('   originalImageUrl: $originalImageUrl');
                debugPrint('   prompt: $newPrompt');

                if (originalImageUrl == null || originalImageUrl.isEmpty) {
                  throw Exception(
                      'El proyecto no tiene imagen original. No se puede regenerar.');
                }

                final regenResponse = await _supabase.functions.invoke(
                  'generate-room-design', // ✅ nombre correcto
                  body: {
                    'originalImageUrl': originalImageUrl,   // obligatorio
                    'prompt': newPrompt,                     // obligatorio
                    if (roomTypeLabel != null) 'roomType': roomTypeLabel,
                    if (styleLabel != null) 'style': styleLabel,
                    if (paletteName != null) 'palette': paletteName,
                    if (paletteColors.isNotEmpty) 'paletteColors': paletteColors,
                    if (selectedFeatures.isNotEmpty) 'features': selectedFeatures
                        .map((id) => _featureLabel(id))
                        .toList(),
                  },
                );

                debugPrint('📦 Regen response data: ${regenResponse.data}');
                debugPrint('📊 Regen response status: ${regenResponse.status}');

                // La Edge Function devuelve 'generatedImageUrl' (camelCase)
                final newImageUrl =
                    regenResponse.data?['generatedImageUrl']?.toString();

                if (newImageUrl == null) {
                  debugPrint('⚠️ No se recibió generatedImageUrl en la respuesta');
                } else {
                  debugPrint('✅ Nueva imagen URL: $newImageUrl');
                }

                // 3. ✅ Limpiar caché y actualizar _project para refrescar la UI
                if (!mounted) return;

                // Evictar imagen antigua Y nueva del caché de Flutter
                final oldImageUrl = _project['generated_image_url']?.toString();
                if (oldImageUrl != null) {
                  await NetworkImage(oldImageUrl).evict();
                }
                if (newImageUrl != null) {
                  await NetworkImage(newImageUrl).evict();
                }

                setState(() {
                  _project['name_projects'] = newName;
                  _project['prompts'] = newPrompt;
                  _project['id_type_room'] = selectedRoomId;
                  _project['id_palette'] = selectedPaletteId;
                  _project['styles'] = selectedStyles;
                  _project['id_features'] = selectedFeatures;
                  _project['updated_at'] = now;
                  if (newImageUrl != null) {
                    _project['generated_image_url'] = newImageUrl;
                    _showingOriginal = false;
                    _imageCacheBuster++; // ✅ fuerza recarga de imagen
                  }
                });

                if (!mounted) return;
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(strings.project_detail_updated_success),
                    backgroundColor: AppColors.passwordStrong,
                  ),
                );
              } catch (e) {
                debugPrint('❌ Error en saveAndRegenerate: $e');
                if (!mounted) return;
                setSheetState(() {
                  isSavingEdit = false;
                  isRegenerating = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(strings.project_detail_error_update_edit(e.toString())),
                    backgroundColor: AppColors.passwordWeak,
                  ),
                );
              }
            }

            final isBusy = isSavingEdit || isRegenerating;

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.92,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, scrollController) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: Form(
                    key: formKey,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        // ── Handle ───────────────────────────────────────
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary(ctx)
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          strings.project_detail_edit_title,
                          style: TextStyle(
                            color: AppColors.textPrimary(ctx),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Nombre ───────────────────────────────────────
                        _sheetLabel(ctx, strings.project_detail_edit_name_label),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: nameController,
                          style: TextStyle(color: AppColors.textPrimary(ctx)),
                          decoration: _sheetInputDecoration(
                            ctx,
                            strings.project_detail_edit_name_hint,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return strings.project_detail_name_required;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // ── Prompt ───────────────────────────────────────
                        _sheetLabel(ctx, strings.project_detail_edit_prompt_label),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: promptController,
                          style: TextStyle(color: AppColors.textPrimary(ctx)),
                          maxLines: 4,
                          decoration: _sheetInputDecoration(
                            ctx,
                            strings.project_detail_edit_prompt_hint,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Tipo de habitación ───────────────────────────
                        _sheetLabel(ctx, strings.project_detail_section_room_type),
                        const SizedBox(height: 10),
                        ProjectDetailRoomSelector(
                          rooms: _rooms,
                          selectedId: selectedRoomId,
                          onSelect: (id) => setSheetState(() => selectedRoomId = id),
                          titleBuilder: _text,
                        ),
                        const SizedBox(height: 24),

                        // ── Estilos ──────────────────────────────────────
                        _sheetLabel(ctx, strings.project_detail_section_styles),
                        const SizedBox(height: 10),
                        ProjectDetailStylesSelector(
                          styles: _styles,
                          selected: selectedStyles,
                          onUpdate: (updated) => setSheetState(() => selectedStyles = updated),
                          titleBuilder: _text,
                        ),
                        const SizedBox(height: 24),

                        // ── Paleta de colores ────────────────────────────
                        _sheetLabel(ctx, strings.project_detail_section_palette),
                        const SizedBox(height: 10),
                        ProjectDetailPaletteSelector(
                          palettes: _palettes,
                          selectedId: selectedPaletteId,
                          onSelect: (id) => setSheetState(() => selectedPaletteId = id),
                          nameBuilder: _text,
                          parseColors: _parseColors,
                        ),
                        const SizedBox(height: 24),

                        // ── Objetos / Features ───────────────────────────
                        _sheetLabel(ctx, strings.project_detail_section_features),
                        const SizedBox(height: 10),
                        ProjectDetailFeaturesSelector(
                          features: _features,
                          selected: selectedFeatures,
                          onUpdate: (updated) => setSheetState(() => selectedFeatures = updated),
                          titleBuilder: _text,
                        ),
                        const SizedBox(height: 32),

                        // ── Botón guardar + regenerar ────────────────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isBusy ? null : saveAndRegenerate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: isBusy
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        isRegenerating
                                            ? strings.project_detail_btn_regenerating
                                            : strings.project_detail_btn_saving,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('✨',
                                          style: TextStyle(fontSize: 18)),
                                      const SizedBox(width: 8),
                                      Text(
                                        strings.project_detail_btn_save_and_regenerate,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Selectores del sheet ───────────────────────────────────────────────────

  // ── Helpers del sheet ──────────────────────────────────────────────────────

  Widget _sheetLabel(BuildContext ctx, String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.textSecondary(ctx),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _sheetInputDecoration(BuildContext ctx, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.textSecondary(ctx).withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: AppColors.background(ctx),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  Future<void> _confirmAndDelete() async {
    final strings = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          strings.project_detail_delete_confirm_title,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          strings.project_detail_delete_confirm_message,
          style: TextStyle(color: AppColors.textSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              strings.project_detail_delete_confirm_cancel,
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.passwordWeak,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              strings.project_detail_delete_confirm_delete,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    try {
      // ✅ FIX 2: Usar _project
      final projectId = _project['id'];
      await _supabase.from('projects').delete().eq('id', projectId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.project_detail_deleted_success),
          backgroundColor: AppColors.passwordStrong,
        ),
      );
      Navigator.pop(context, 'deleted');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.project_detail_error_delete(e.toString())),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  void _openImageFullscreen(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white));
                },
                errorBuilder: (context, error, stack) => const Icon(
                  Icons.broken_image_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final isPublic = _project['public_state'] == true;
    // ✅ FIX 2: Todo el build lee desde _project
    final projectName = _project['name_projects'] ?? strings.projects_untitled;
    final roomId = _project['id_type_room']?.toString();
    final styles = _toStringList(_project['styles']);
    final features = _toStringList(_project['id_features']);
    final paletteId = _project['id_palette']?.toString();
    final paletteColors = _paletteColors(paletteId);
    final paletteName = _paletteName(paletteId);
    final generatedImageUrl = _project['generated_image_url']?.toString();
    final originalImageUrl = _project['original_image_url']?.toString();
    final activeImageUrl = _showingOriginal
        ? originalImageUrl
        : (generatedImageUrl ?? originalImageUrl);

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary(context),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined,
                color: AppColors.textPrimary(context)),
            tooltip: strings.project_detail_btn_edit,
            onPressed: _isLoadingMetadata ? null : _openEditSheet,
          ),
          IconButton(
            icon: _isDeleting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.passwordWeak,
                    ),
                  )
                : Icon(Icons.delete_outline, color: AppColors.passwordWeak),
            tooltip: strings.project_detail_btn_delete,
            onPressed: (_isLoadingMetadata || _isDeleting)
                ? null
                : _confirmAndDelete,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoadingMetadata
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectDetailHeader(
                    imageUrl: activeImageUrl,
                    title: projectName,
                    hasOriginal: originalImageUrl != null,
                    hasGenerated: generatedImageUrl != null,
                    showingOriginal: _showingOriginal,
                    onShowOriginal: () => setState(() => _showingOriginal = true),
                    onShowGenerated: () => setState(() => _showingOriginal = false),
                    originalLabel: strings.project_detail_toggle_original,
                    generatedLabel: strings.project_detail_toggle_generated,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── ESTADO ───────────────────────────────────────
                        ProjectDetailSectionTitle(
                          title: strings.project_detail_section_status,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isPublic
                                    ? AppEmojis.publicProject
                                    : AppEmojis.privateProject,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isPublic
                                    ? strings.project_detail_status_public
                                    : strings.project_detail_status_private,
                                style: TextStyle(
                                  color: isPublic
                                      ? AppColors.passwordStrong
                                      : AppColors.passwordWeak,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── TIPO DE HABITACIÓN ──────────────────────────
                        ProjectDetailSectionTitle(
                          title: strings.project_detail_section_room_type,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_roomIcon(roomId),
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                _roomName(roomId),
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── ESTILOS ─────────────────────────────────────
                        if (styles.isNotEmpty) ...[
                          ProjectDetailSectionTitle(
                            title: strings.project_detail_section_styles,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: styles
                                .map((s) => ProjectDetailStyleTag(
                                      icon: _styleIcon(s),
                                      label: _styleLabel(s),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── PALETA ──────────────────────────────────────
                        if (paletteId != null &&
                            paletteColors.isNotEmpty) ...[
                          ProjectDetailSectionTitle(
                            title: strings.project_detail_section_palette,
                          ),
                          const SizedBox(height: 12),
                          ProjectDetailPaletteRow(colors: paletteColors),
                          const SizedBox(height: 10),
                          Text(
                            paletteName,
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── FEATURES ────────────────────────────────────
                        if (features.isNotEmpty) ...[
                          ProjectDetailSectionTitle(
                            title: strings.project_detail_section_features,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: features
                                .map((f) => ProjectDetailFeatureTag(
                                      icon: _featureIcon(f),
                                      label: _featureLabel(f),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── PROMPT ──────────────────────────────────────
                        if (_project['prompts'] != null &&
                            _project['prompts'].toString().isNotEmpty) ...[
                          ProjectDetailSectionTitle(
                            title: strings.project_detail_section_prompt,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface(context),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppEmojis.prompt,
                                    style: const TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _project['prompts'].toString(),
                                    style: TextStyle(
                                      color: AppColors.textPrimary(context),
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── TIEMPOS ─────────────────────────────────────
                        ProjectDetailSectionTitle(
                          title: strings.project_detail_section_times,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ProjectDetailInfoCard(
                              emoji: AppEmojis.createdAt,
                              label: strings.project_detail_created_at,
                              value: _formatDate(_project['created_at']),
                            ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ProjectDetailInfoCard(
                                emoji: AppEmojis.updatedAt,
                                label: strings.project_detail_updated_at,
                                value: _formatDate(_project['updated_at']),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // ── BOTÓN PUBLICAR / PRIVATIZAR ─────────────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _togglePublicState,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPublic
                                  ? AppColors.passwordWeak
                                  : AppColors.passwordStrong,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isPublic
                                            ? AppEmojis.privateProject
                                            : AppEmojis.publicProject,
                                        style:
                                            const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isPublic
                                            ? strings
                                                .project_detail_btn_make_private
                                            : strings
                                                .project_detail_btn_publish,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

}