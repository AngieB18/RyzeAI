import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/presentation/features/camera/screens/result_screen.dart';
import 'package:ryzeai/presentation/features/camera/widgets/widgets_style_inspiration_screen.dart';

class StyleInspirationScreen extends StatefulWidget {
  final File image;
  const StyleInspirationScreen({super.key, required this.image});

  @override
  State<StyleInspirationScreen> createState() => _StyleInspirationScreenState();
}

class _StyleInspirationScreenState extends State<StyleInspirationScreen> {
  final _supabase = Supabase.instance.client;

  String? _selectedRoom;
  String? _selectedStyle;
  String? _selectedPalette;
  String? _cameraOption;
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isGenerating = false;
  bool _loadingStyles = true;
  List<String> _userStyles = [];
  final Set<String> _selectedFurniture = {};

  final List<Map<String, dynamic>> _rooms = [
    {'icon': Icons.chair, 'label': 'Sala de estar'},
    {'icon': Icons.bed, 'label': 'Dormitorio'},
    {'icon': Icons.kitchen, 'label': 'Cocina'},
    {'icon': Icons.bathtub, 'label': 'Baño'},
    {'icon': Icons.computer, 'label': 'Oficina'},
    {'icon': Icons.dining, 'label': 'Comedor'},
    {'icon': Icons.child_care, 'label': 'Habitación infantil'},
    {'icon': Icons.sports_esports, 'label': 'Sala de juegos'},
    {'icon': Icons.fitness_center, 'label': 'Gimnasio'},
    {'icon': Icons.yard, 'label': 'Terraza'},
    {'icon': Icons.garage, 'label': 'Garaje'},
    {'icon': Icons.local_laundry_service, 'label': 'Lavandería'},
  ];

  final List<Map<String, dynamic>> _styles = [
    {
      'key': 'minimalista',
      'label': 'Minimalista',
      'image': 'https://images.unsplash.com/photo-1616594039964-ae9021a400a0?w=300&q=80',
    },
    {
      'key': 'natural',
      'label': 'Natural',
      'image': 'https://images.unsplash.com/photo-1518136247453-74e7b5265980?w=300&q=80',
    },
    {
      'key': 'tradicional',
      'label': 'Tradicional',
      'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&q=80',
    },
    {
      'key': 'rustico',
      'label': 'Rústico',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=300&q=80',
    },
  ];

  final List<Map<String, dynamic>> _palettes = [
    {
      'key': 'luxury',
      'label': 'Lujo Moderno',
      'colors': [Color(0xFF1A1A1A), Color(0xFFF5B800), Color(0xFF9E9E9E), Color(0xFFFFFFFF)],
    },
    {
      'key': 'wood',
      'label': 'Maderas Naturales',
      'colors': [Color(0xFF8B5E3C), Color(0xFFBC8A6A), Color(0xFFD4B8A0), Color(0xFFF5F0EB)],
    },
    {
      'key': 'ocean',
      'label': 'Océano Sereno',
      'colors': [Color(0xFF1B4F72), Color(0xFF2E86C1), Color(0xFF85C1E9), Color(0xFFEBF5FB)],
    },
    {
      'key': 'forest',
      'label': 'Bosque Vivo',
      'colors': [Color(0xFF1E8449), Color(0xFF52BE80), Color(0xFFA9DFBF), Color(0xFFF0FFF0)],
    },
    {
      'key': 'pastel',
      'label': 'Pastel Suave',
      'colors': [Color(0xFFF8BBD0), Color(0xFFCE93D8), Color(0xFF80DEEA), Color(0xFFFFF9C4)],
    },
    {
      'key': 'dark',
      'label': 'Oscuro Elegante',
      'colors': [Color(0xFF0D0D0D), Color(0xFF2C2C2C), Color(0xFF4A4A4A), Color(0xFF888888)],
    },
    {
      'key': 'earth',
      'label': 'Tierra Cálida',
      'colors': [Color(0xFF6D4C41), Color(0xFFA1887F), Color(0xFFD7CCC8), Color(0xFFF5F5DC)],
    },
    {
      'key': 'nordic',
      'label': 'Nórdico Frío',
      'colors': [Color(0xFF455A64), Color(0xFF78909C), Color(0xFFB0BEC5), Color(0xFFECEFF1)],
    },
  ];

  final List<Map<String, dynamic>> _furniture = [
    {'emoji': '🛋️', 'label': 'Sofá'},
    {'emoji': '🪑', 'label': 'Silla'},
    {'emoji': '🛏️', 'label': 'Cama'},
    {'emoji': '🖥️', 'label': 'Escritorio'},
    {'emoji': '🪴', 'label': 'Planta'},
    {'emoji': '🖼️', 'label': 'Cuadro'},
    {'emoji': '💡', 'label': 'Lámpara'},
    {'emoji': '📚', 'label': 'Estantería'},
    {'emoji': '🛁', 'label': 'Bañera'},
    {'emoji': '🪞', 'label': 'Espejo'},
  ];

  bool get _canGenerate =>
      _selectedRoom != null &&
      _selectedStyle != null &&
      _selectedPalette != null &&
      _nameController.text.trim().isNotEmpty &&
      _promptController.text.trim().isNotEmpty &&
      !_isGenerating;

  @override
  void initState() {
    super.initState();
    _loadUserStyles();
    // Rebuild when text fields change so button enables/disables
    _nameController.addListener(() => setState(() {}));
    _promptController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _loadUserStyles() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;
      final data = await _supabase
          .from('users')
          .select('styles')
          .eq('id', userId)
          .single();
      final rawStyles = data['styles'];
      List<String> styles = [];
      if (rawStyles is List) {
        styles = rawStyles.map((e) => e.toString()).toList();
      }
      if (mounted) {
        setState(() {
          _userStyles = styles;
          _loadingStyles = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingStyles = false);
    }
  }

  void _generateIdea() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isGenerating = false);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ResultScreen(
            resultImageUrl:
                'https://images.unsplash.com/photo-1618221195710-dd6b41faeaa6?q=80&w=1000',
          ),
        ),
      );
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

                    // ── 1. NOMBRE DEL PROYECTO ─────────────────
                    _SectionHeader(
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
                          color: AppColors.textSecondary(context).withOpacity(0.4),
                        ),
                        filled: true,
                        fillColor: AppColors.surface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.inputBorder(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── 2. TIPO DE HABITACIÓN ──────────────────
                    _SectionHeader(
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
                          final selected = _selectedRoom == room['label'];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRoom = room['label']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
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
                                  Icon(
                                    room['icon'] as IconData,
                                    size: 15,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.textSecondary(context),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    room['label'],
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

                    // ── 3. ESTILO ──────────────────────────────
                    _SectionHeader(
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
                          final selected = _selectedStyle == style['key'];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedStyle = style['key']),
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
                                    Image.network(
                                      style['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                          color: AppColors.surface(context)),
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
                                        style['label'],
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
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.check,
                                              size: 12, color: Colors.white),
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

                    // ── 4. PALETA DE COLORES ───────────────────
                    _SectionHeader(
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
                          final selected = _selectedPalette == palette['key'];
                          final colors = palette['colors'] as List<Color>;
                          return GestureDetector(
                            onTap: () => setState(
                                () => _selectedPalette = palette['key']),
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
                                        .map((c) => Container(
                                              width: 22,
                                              height: 22,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              decoration: BoxDecoration(
                                                color: c,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white24,
                                                    width: 1),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    palette['label'],
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

                    // ── 5. MUEBLES Y OBJETOS ───────────────────
                    _SectionHeader(
                      title: 'Añadir muebles y objetos',
                      badge: 'Opcional',
                      badgeColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Elige hasta 5 objetos para sugerir en tu espacio',
                      style: TextStyle(
                          color: AppColors.textSecondary(context), fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 105,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _furniture.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) {
                          final item = _furniture[i];
                          final selected =
                              _selectedFurniture.contains(item['label']);
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (selected) {
                                _selectedFurniture.remove(item['label']);
                              } else if (_selectedFurniture.length < 5) {
                                _selectedFurniture.add(item['label']);
                              }
                            }),
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
                                  Text(item['emoji'],
                                      style: const TextStyle(fontSize: 28)),
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

                    // ── 6. CÁMARA Y FOTO ──────────────────────
                    _SectionHeader(
                      title: 'Cámara y foto',
                      badge: 'Opcional',
                      badgeColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _CameraChip(
                          icon: Icons.home_work_outlined,
                          label: 'Mantener detalles',
                          desc: 'Conserva elementos existentes',
                          value: 'details',
                          selected: _cameraOption == 'details',
                          onTap: () =>
                              setState(() => _cameraOption = 'details'),
                        ),
                        _CameraChip(
                          icon: Icons.crop_free,
                          label: 'Mismo ángulo',
                          desc: 'Mantiene la perspectiva original',
                          value: 'same_angle',
                          selected: _cameraOption == 'same_angle',
                          onTap: () =>
                              setState(() => _cameraOption = 'same_angle'),
                        ),
                        _CameraChip(
                          icon: Icons.rotate_90_degrees_cw_outlined,
                          label: 'Cambiar ángulo',
                          desc: 'La IA elige un ángulo mejor',
                          value: 'change_angle',
                          selected: _cameraOption == 'change_angle',
                          onTap: () =>
                              setState(() => _cameraOption = 'change_angle'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── 7. PROMPT ─────────────────────────────
                    _SectionHeader(
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
                          color: AppColors.textSecondary(context).withOpacity(0.5),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: AppColors.surface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppColors.inputBorder(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── BOTÓN GENERAR ─────────────────────────
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
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isGenerating
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
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

// ── Widgets locales ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String badge;
  final Color badgeColor;
  const _SectionHeader(
      {required this.title,
      required this.badge,
      required this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _CameraChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _CameraChip({
    required this.icon,
    required this.label,
    required this.desc,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: (MediaQuery.of(context).size.width - 56) / 2,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.inputBorder(context),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 20,
                color: selected
                    ? AppColors.primary
                    : AppColors.textSecondary(context)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.primary
                    : AppColors.textPrimary(context),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: TextStyle(
                  color: AppColors.textSecondary(context), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}