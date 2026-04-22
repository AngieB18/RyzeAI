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

  String? _selectedCategory;
  String? _selectedSpace;
  String? _selectedPalette;
  String? _selectedStyle; // ← estilo seleccionado
  final TextEditingController _promptController = TextEditingController();

  bool _isGenerating = false;
  bool _loadingStyles = true;
  List<String> _userStyles = []; // ← se carga desde Supabase

  final Map<String, Map<String, dynamic>> _categories = {
    'living': {
      'icon': '🛋️',
      'label': 'Sala',
      'spaces': [
        {'icon': '📺', 'label': 'Zona TV'},
        {'icon': '☕', 'label': 'Rincón Café'},
      ]
    },
    'office': {
      'icon': '💻',
      'label': 'Oficina',
      'spaces': [
        {'icon': '⌨️', 'label': 'Escritorio'},
        {'icon': '📚', 'label': 'Biblioteca'},
      ]
    },
    'bedroom': {
      'icon': '🛏️',
      'label': 'Dormitorio',
      'spaces': [
        {'icon': '🧸', 'label': 'Cuna'},
        {'icon': '👗', 'label': 'Vestidor'},
      ]
    },
  };

  final List<Map<String, dynamic>> _palettes = [
    {
      'key': 'warm',
      'label': 'Cálido',
      'colors': [Colors.orange, Colors.brown]
    },
    {
      'key': 'cold',
      'label': 'Frío',
      'colors': [Colors.blue, Colors.cyan]
    },
    {
      'key': 'neutral',
      'label': 'Neutral',
      'colors': [Colors.grey, Colors.white]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserStyles();
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

      if (rawStyles != null) {
        if (rawStyles is List) {
          styles = rawStyles.map((e) => e.toString()).toList();
        } else if (rawStyles is String) {
          // por si viene como JSON string
          styles = List<String>.from(
            (rawStyles as String)
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '')
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty),
          );
        }
      }

      if (mounted) {
        setState(() {
          _userStyles = styles;
          _loadingStyles = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando estilos: $e');
      if (mounted) setState(() => _loadingStyles = false);
    }
  }

  void _generateIdea() async {
    setState(() => _isGenerating = true);

    // TODO: Integrar servicio de Anthropic o Supabase Edge Functions
    // Enviando: widget.image, _selectedCategory, _selectedSpace,
    //           _selectedPalette, _selectedStyle, _promptController.text

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isGenerating = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(
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

                    // ── Mis Estilos desde Supabase ──
                    if (_loadingStyles)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else
                      UserStylesChips(
                        styles: _userStyles,
                        selectedStyle: _selectedStyle,
                        onSelect: (val) =>
                            setState(() => _selectedStyle = val),
                      ),

                    ColorPaletteSelector(
                      palettes: _palettes,
                      selectedPalette: _selectedPalette,
                      onSelect: (val) =>
                          setState(() => _selectedPalette = val),
                    ),

                    CategoryGrid(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onSelect: (val) {
                        setState(() {
                          _selectedCategory = val;
                          _selectedSpace = null;
                        });
                      },
                    ),

                    if (_selectedCategory != null)
                      SpaceChips(
                        spaces: _categories[_selectedCategory]!['spaces'],
                        selectedSpace: _selectedSpace,
                        onSelect: (val) =>
                            setState(() => _selectedSpace = val),
                      ),

                    const SizedBox(height: 24),

                    Text(
                      "¿Qué quieres cambiar o agregar?",
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      style:
                          TextStyle(color: AppColors.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText:
                            "Ej: Pon un escritorio de madera, un cuadro moderno y una planta alta en la esquina...",
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary(context)
                              .withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: AppColors.surface(context),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppColors.inputBorder(context)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                      ),
                    ),

                    GenerateButton(
                      generating: _isGenerating,
                      onPressed: _generateIdea,
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