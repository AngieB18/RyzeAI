import 'dart:io';
import 'package:flutter/material.dart';
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
  String? _selectedCategory;
  String? _selectedSpace;
  String? _selectedPalette;
  final TextEditingController _promptController = TextEditingController();

  bool _isGenerating = false;
  List<String> _userStyles = ["Minimalista", "Moderno"];

  final Map<String, Map<String, dynamic>> _categories = {
    'living': {'icon': '🛋️', 'label': 'Sala', 'spaces': [
      {'icon': '📺', 'label': 'Zona TV'},
      {'icon': '☕', 'label': 'Rincón Café'},
    ]},
    'office': {'icon': '💻', 'label': 'Oficina', 'spaces': [
      {'icon': '⌨️', 'label': 'Escritorio'},
      {'icon': '📚', 'label': 'Biblioteca'},
    ]},
    'bedroom': {'icon': '🛏️', 'label': 'Dormitorio', 'spaces': [
      {'icon': '🧸', 'label': 'Cuna'},
      {'icon': '👗', 'label': 'Vestidor'},
    ]},
  };

  final List<Map<String, dynamic>> _palettes = [
    {'key': 'warm', 'label': 'Cálido', 'colors': [Colors.orange, Colors.brown]},
    {'key': 'cold', 'label': 'Frío', 'colors': [Colors.blue, Colors.cyan]},
    {'key': 'neutral', 'label': 'Neutral', 'colors': [Colors.grey, Colors.white]},
  ];

  void _generateIdea() async {
    setState(() => _isGenerating = true);

    // TODO: Integrar servicio de Anthropic o Supabase Edge Functions
    // Enviando: widget.image, _selectedCategory, _selectedSpace, _selectedPalette, _promptController.text

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isGenerating = false);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(
            resultImageUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faeaa6?q=80&w=1000',
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

                    UserStylesChips(styles: _userStyles),

                    ColorPaletteSelector(
                      palettes: _palettes,
                      selectedPalette: _selectedPalette,
                      onSelect: (val) => setState(() => _selectedPalette = val),
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
                        onSelect: (val) => setState(() => _selectedSpace = val),
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
                      style: TextStyle(color: AppColors.textPrimary(context)),
                      decoration: InputDecoration(
                        hintText: "Ej: Pon un escritorio de madera, un cuadro moderno y una planta alta en la esquina...",
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary(context).withOpacity(0.5),
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