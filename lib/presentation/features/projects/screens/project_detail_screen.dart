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
      setState(() {
        _isLoadingMetadata = false;
      });
    }
  }

  Future<void> _togglePublicState() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final projectId = widget.project['id'];
      final currentState = widget.project['public_state'] == true;
      await _supabase
          .from('projects')
          .update({'public_state': !currentState})
          .eq('id', projectId);

      if (!mounted) return;

      widget.project['public_state'] = !currentState;
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            currentState
                ? 'El proyecto ahora es privado'
                : 'El proyecto ahora es público',
          ),
          backgroundColor:
              currentState ? AppColors.passwordWeak : AppColors.passwordStrong,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar el estado: $e'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  String _roomName(String? roomId) {
    final room = _rooms.firstWhere(
      (item) => item['id']?.toString() == roomId,
      orElse: () => {},
    );

    if (room.isNotEmpty) {
      return room['name_type_room']?.toString() ?? 'Habitación';
    }

    return 'Habitación';
  }

  String _styleLabel(String styleId) {
    final style = _styles.firstWhere(
      (item) => item['id']?.toString() == styleId,
      orElse: () => {},
    );

    if (style.isNotEmpty) {
      return style['name']?.toString() ?? 'Estilo';
    }

    return styleId.replaceAll('_', ' ').replaceAll('-', ' ').trim().toUpperCase();
  }

  String _styleIcon(String styleId) {
    final style = _styles.firstWhere(
      (item) => item['id']?.toString() == styleId,
      orElse: () => {},
    );

    if (style.isNotEmpty) {
      final icon = style['icon']?.toString();
      if (icon != null && icon.isNotEmpty) {
        return icon;
      }
    }

    return '🎨';
  }

  Map<String, dynamic>? _findPalette(String? paletteId) {
    if (paletteId == null) return null;
    return _palettes.firstWhere(
      (item) => item['id']?.toString() == paletteId,
      orElse: () => {},
    ) as Map<String, dynamic>?;
  }

  String _paletteName(String? paletteId) {
    final palette = _findPalette(paletteId);
    if (palette != null && palette.isNotEmpty) {
      return palette['name_palette']?.toString() ?? 'Paleta';
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

    if (feature.isNotEmpty) {
      return feature['name_feature']?.toString() ?? 'Objeto';
    }

    return 'Objeto';
  }

  String _featureIcon(String featureId) {
    final feature = _features.firstWhere(
      (item) => item['id']?.toString() == featureId,
      orElse: () => {},
    );

    if (feature.isNotEmpty) {
      final icon = feature['icon_feature']?.toString();
      if (icon != null && icon.isNotEmpty) {
        return icon;
      }
    }

    return '🔹';
  }

  List<Color> _parseColors(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString())
          .map((hex) => hex.replaceAll('#', '').trim())
          .where((hex) => hex.isNotEmpty)
          .map((hex) => Color(int.parse('FF$hex', radix: 16)))
          .toList();
    }

    if (value is String) {
      return value
          .split(',')
          .map((item) => item.toString())
          .map((hex) => hex.replaceAll('#', '').trim())
          .where((hex) => hex.isNotEmpty)
          .map((hex) => Color(int.parse('FF$hex', radix: 16)))
          .toList();
    }

    return [];
  }

  List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String && value.isNotEmpty) {
      return [value];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final isPublic = widget.project['public_state'] == true;
    final projectName = widget.project['name_projects'] ?? strings.projects_untitled;
    final room = _roomName(widget.project['id_type_room']?.toString());
    final styles = _toStringList(widget.project['styles']);
    final features = _toStringList(widget.project['id_features']);
    final paletteId = widget.project['id_palette']?.toString();
    final paletteColors = _paletteColors(paletteId);
    final paletteName = _paletteName(paletteId);
    final imageUrl = widget.project['generated_image_url']?.toString() ?? widget.project['original_image_url']?.toString();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: AppColors.darkHeader,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(context, imageUrl, projectName, isPublic),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Vista rápida'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildBadge('Habitación', room),
                      const SizedBox(width: 10),
                      _buildBadge('Estado', isPublic ? 'Público' : 'Privado', color: isPublic ? AppColors.passwordStrong : AppColors.passwordWeak),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (styles.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Estilos'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: styles.map((styleId) {
                        return _buildStyleTag(context, styleId);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (paletteId != null && paletteColors.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Paleta de colores'),
                    const SizedBox(height: 12),
                    _buildPaletteRow(paletteColors),
                    const SizedBox(height: 14),
                    Text(
                      paletteName,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (features.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Muebles y objetos'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: features.map((featureId) {
                        return _buildFeatureTag(context, featureId);
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (widget.project['prompts'] != null && widget.project['prompts'].toString().isNotEmpty) ...[
                    _buildSectionTitle(context, '¿Qué quieres cambiar o agregar?'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        widget.project['prompts'].toString(),
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildSectionTitle(context, 'Tiempos'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInfoCard(context, 'Creado', _formatDate(widget.project['created_at']))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInfoCard(context, 'Actualizado', _formatDate(widget.project['updated_at']))),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _togglePublicState,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPublic ? AppColors.passwordWeak : AppColors.passwordStrong,
                        padding: const EdgeInsets.symmetric(vertical: 18),
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              isPublic ? 'Poner privado' : 'Publicar proyecto',
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

  Widget _buildHeaderImage(BuildContext context, String? imageUrl, String title, bool isPublic) {
    return Stack(
      children: [
        Container(
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
        Container(
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
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background(context).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isPublic ? 'Proyecto público' : 'Proyecto privado',
                  style: TextStyle(
                    color: isPublic ? AppColors.passwordStrong : AppColors.passwordWeak,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu proyecto guardado se ve genial aquí. Ajusta su estado cuando quieras.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildBadge(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
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
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimary(context),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteRow(List<Color> colors) {
    return Row(
      children: colors.map((color) {
        return Expanded(
          child: Container(
            height: 56,
            margin: const EdgeInsets.only(right: 10),
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
    final label = _styleLabel(styleId);
    final icon = _styleIcon(styleId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            label,
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
    final label = _featureLabel(featureId);
    final icon = _featureIcon(featureId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            label,
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

  String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'No disponible';
    try {
      final date = dateValue is DateTime
          ? dateValue
          : DateTime.parse(dateValue.toString());
      return '${date.day}/${date.month}/${date.year} · ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateValue.toString();
    }
  }
}
