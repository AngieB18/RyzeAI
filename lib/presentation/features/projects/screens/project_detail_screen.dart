import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/feature_ser/feature_service.dart';
import '../../../../core/services/palette/palette_servicio.dart';
import '../../../../core/services/styles/style_service.dart';
import '../../../../core/services/type_room/type_room_service.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';

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
  bool _isLoadingMetadata = true;

  List<Map<String, dynamic>> _rooms = [];
  List<Map<String, dynamic>> _styles = [];
  List<Map<String, dynamic>> _palettes = [];
  List<Map<String, dynamic>> _features = [];

  bool _showingOriginal = false;

  @override
  void initState() {
    super.initState();
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

  // ─────────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────────

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
    if (roomId == null) return 'Habitación';
    final room = _rooms.firstWhere(
      (item) => item['id']?.toString() == roomId,
      orElse: () => {},
    );
    if (room.isNotEmpty) return _text(room['name_type_room']);
    return 'Habitación';
  }

  String _roomIcon(String? roomId) {
    if (roomId == null) return '🏠';
    final room = _rooms.firstWhere(
      (item) => item['id']?.toString() == roomId,
      orElse: () => {},
    );
    if (room.isNotEmpty) {
      final icon = room['icon_room']?.toString();
      if (icon != null && icon.isNotEmpty) return icon;
    }
    return '🏠';
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
    return '🎨';
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
    if (paletteId == null) return 'Paleta';
    final palette = _findPalette(paletteId);
    if (palette != null && palette.isNotEmpty) {
      return _text(palette['name_palette']);
    }
    return 'Paleta';
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
    return 'Objeto';
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
    return '🔹';
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
    if (dateValue == null) return 'No disponible';
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

  // ─────────────────────────────────────────────────────────────────────────────
  // ACCIONES
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _togglePublicState() async {
    setState(() => _isSaving = true);
    try {
      final projectId = widget.project['id'];
      final currentState = widget.project['public_state'] == true;
      await _supabase
          .from('projects')
          .update({'public_state': !currentState}).eq('id', projectId);

      if (!mounted) return;
      widget.project['public_state'] = !currentState;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentState
                ? 'El proyecto ahora es privado'
                : 'El proyecto ahora es público',
          ),
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
          content: Text('Error al actualizar el estado: $e'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  // ── Abre la imagen en pantalla completa con zoom ──────────────────────────
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
                    child: CircularProgressIndicator(color: Colors.white),
                  );
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

  // ─────────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final isPublic = widget.project['public_state'] == true;
    final projectName =
        widget.project['name_projects'] ?? strings.projects_untitled;
    final roomId = widget.project['id_type_room']?.toString();
    final styles = _toStringList(widget.project['styles']);
    final features = _toStringList(widget.project['id_features']);
    final paletteId = widget.project['id_palette']?.toString();
    final paletteColors = _paletteColors(paletteId);
    final paletteName = _paletteName(paletteId);
    final generatedImageUrl =
        widget.project['generated_image_url']?.toString();
    final originalImageUrl = widget.project['original_image_url']?.toString();
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
      ),
      body: _isLoadingMetadata
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header con imagen y toggle ────────────────────────
                  _buildHeaderImage(
                    context,
                    activeImageUrl,
                    projectName,
                    isPublic,
                    hasOriginal: originalImageUrl != null,
                    hasGenerated: generatedImageUrl != null,
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── ESTADO ──────────────────────────────────────
                        _buildSectionTitle(context, 'Estado'),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface(context),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            isPublic ? '🌍  Público' : '🔒  Privado',
                            style: TextStyle(
                              color: isPublic
                                  ? AppColors.passwordStrong
                                  : AppColors.passwordWeak,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── TIPO DE HABITACIÓN ──────────────────────────
                        _buildSectionTitle(context, 'Tipo de habitación'),
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

                        // ── Estilos ─────────────────────────────────────
                        if (styles.isNotEmpty) ...[
                          _buildSectionTitle(context, 'Estilos'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: styles
                                .map((s) => _buildStyleTag(context, s))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── Paleta de colores ───────────────────────────
                        if (paletteId != null && paletteColors.isNotEmpty) ...[
                          _buildSectionTitle(context, 'Paleta de colores'),
                          const SizedBox(height: 12),
                          _buildPaletteRow(paletteColors),
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

                        // ── Muebles y objetos ───────────────────────────
                        if (features.isNotEmpty) ...[
                          _buildSectionTitle(context, 'Muebles y objetos'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: features
                                .map((f) => _buildFeatureTag(context, f))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ── Prompt ──────────────────────────────────────
                        if (widget.project['prompts'] != null &&
                            widget.project['prompts']
                                .toString()
                                .isNotEmpty) ...[
                          _buildSectionTitle(
                              context, '¿Qué quieres cambiar o agregar?'),
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
                                const Text('💬',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.project['prompts'].toString(),
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

                        // ── Tiempos ─────────────────────────────────────
                        _buildSectionTitle(context, 'Tiempos'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                '📅  Creado',
                                _formatDate(widget.project['created_at']),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                context,
                                '🔄  Actualizado',
                                _formatDate(widget.project['updated_at']),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // ── Botón publicar / privatizar ─────────────────
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
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                                : Text(
                                    isPublic
                                        ? '🔒  Poner privado'
                                        : '🌍  Publicar proyecto',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
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

  // ─────────────────────────────────────────────────────────────────────────────
  // WIDGETS INTERNOS
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildHeaderImage(
    BuildContext context,
    String? imageUrl,
    String title,
    bool isPublic, {
    required bool hasOriginal,
    required bool hasGenerated,
  }) {
    return Stack(
      children: [
        // ── Imagen tocable que abre fullscreen ──────────────────────────
        GestureDetector(
          onTap: () {
            if (imageUrl != null) _openImageFullscreen(context, imageUrl);
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Container(
              key: ValueKey(imageUrl),
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkHeader.withValues(alpha: 0.15),
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
        ),

        // ── Gradiente oscuro abajo ──────────────────────────────────────
        IgnorePointer(
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background(context).withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
        ),

        // ── Icono de lupa como pista visual ────────────────────────────
        if (imageUrl != null)
          Positioned(
            bottom: 50,
            right: 20,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.zoom_in_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ),
          ),

        // ── Título ──────────────────────────────────────────────────────
        Positioned(
          bottom: 20,
          left: 20,
          right: 60,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ── Toggle Original / Generada ──────────────────────────────────
        if (hasOriginal && hasGenerated)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _toggleChip('Original', _showingOriginal, () {
                    setState(() => _showingOriginal = true);
                  }),
                  _toggleChip('Generada', !_showingOriginal, () {
                    setState(() => _showingOriginal = false);
                  }),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _toggleChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildPaletteRow(List<Color> colors) {
    return Row(
      children: colors.map((color) {
        return Expanded(
          child: Container(
            height: 56,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStyleTag(BuildContext context, String styleId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_styleIcon(styleId), style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            _styleLabel(styleId),
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(BuildContext context, String featureId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_featureIcon(featureId), style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            _featureLabel(featureId),
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}