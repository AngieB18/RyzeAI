// lib/home/screens/style_inspiration_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/services/remote_config_service.dart';
import '../../generated/l10n.dart';

class StyleInspirationScreen extends StatefulWidget {
  final File? initialImage;

  const StyleInspirationScreen({super.key, this.initialImage});

  @override
  State<StyleInspirationScreen> createState() => _StyleInspirationScreenState();
}

class _StyleInspirationScreenState extends State<StyleInspirationScreen> {
  String? _selectedCategory;
  String? _selectedSpace;
  String? _selectedPalette;
  bool _generating = false;
  String? _aiDescription;
  List<String> _images = [];
  final _customController = TextEditingController();
  List<String> _userStyles = [];

  @override
  void initState() {
    super.initState();
    _loadUserStyles();
  }

  Future<void> _loadUserStyles() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        if (doc.exists && doc.data()?['styles'] != null) {
          setState(() {
            _userStyles = List<String>.from(doc.data()!['styles'] as List);
          });
        }
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Map<String, Map<String, dynamic>> _getCategories(S l) => {
    'home': {
      'label': l.spaceHome,
      'icon': '🏠',
      'spaces': [
        {'key': 'bedroom', 'label': l.spaceRoom, 'icon': '🛏️'},
        {'key': 'living', 'label': l.spaceLiving, 'icon': '🛋️'},
        {'key': 'bathroom', 'label': l.spaceBathroom, 'icon': '🚿'},
        {'key': 'kitchen', 'label': l.spaceKitchen, 'icon': '🍳'},
      ],
    },
    'office': {
      'label': l.spaceOffice,
      'icon': '🏢',
      'spaces': [
        {'key': 'reception', 'label': l.spaceReception, 'icon': '🪑'},
        {'key': 'meeting', 'label': l.spaceMeeting, 'icon': '📋'},
        {'key': 'cafeteria', 'label': l.spaceCafeteria, 'icon': '☕'},
      ],
    },
    'restaurant': {
      'label': l.spaceRestaurant,
      'icon': '🍽️',
      'spaces': [
        {'key': 'dining', 'label': l.spaceDiningRoom, 'icon': '🍽️'},
        {'key': 'bar', 'label': l.spaceBar, 'icon': '🍸'},
        {'key': 'cafeteria', 'label': l.spaceCafeteria, 'icon': '☕'},
      ],
    },
    'store': {
      'label': l.spaceStore,
      'icon': '🏪',
      'spaces': [
        {'key': 'shop', 'label': l.spaceShop, 'icon': '🛍️'},
        {'key': 'storefront', 'label': l.spaceStorefront, 'icon': '🪟'},
        {'key': 'reception', 'label': l.spaceReception, 'icon': '🪑'},
      ],
    },
    'custom': {'label': l.spaceCustom, 'icon': '✏️', 'spaces': []},
  };

  List<Map<String, dynamic>> _getPalettes() => [
    {
      'key': 'neutral',
      'label': 'Neutral',
      'colors': [
        const Color(0xFFF5F5F5),
        const Color(0xFFE0E0E0),
        const Color(0xFF9E9E9E),
        const Color(0xFF616161),
      ],
    },
    {
      'key': 'warm',
      'label': 'Warm',
      'colors': [
        const Color(0xFFFFE0B2),
        const Color(0xFFFFCC80),
        const Color(0xFFFF8A65),
        const Color(0xFFE64A19),
      ],
    },
    {
      'key': 'cool',
      'label': 'Cool',
      'colors': [
        const Color(0xFFE3F2FD),
        const Color(0xFF90CAF9),
        const Color(0xFF42A5F5),
        const Color(0xFF1565C0),
      ],
    },
    {
      'key': 'earthy',
      'label': 'Earthy',
      'colors': [
        const Color(0xFFEFEBE9),
        const Color(0xFFBCAAA4),
        const Color(0xFF8D6E63),
        const Color(0xFF4E342E),
      ],
    },
    {
      'key': 'monochrome',
      'label': 'Monochrome',
      'colors': [
        const Color(0xFFFFFFFF),
        const Color(0xFFBDBDBD),
        const Color(0xFF616161),
        const Color(0xFF212121),
      ],
    },
    {
      'key': 'vibrant',
      'label': 'Vibrant',
      'colors': [
        const Color(0xFFFF1744),
        const Color(0xFFFF9100),
        const Color(0xFF00E676),
        const Color(0xFF2979FF),
      ],
    },
  ];

  Future<void> _generateIdeas() async {
    final spaceName = _selectedCategory == 'custom'
        ? _customController.text.trim()
        : _selectedSpace;

    if (spaceName == null || spaceName.isEmpty) return;

    setState(() {
      _generating = true;
      _aiDescription = null;
      _images = [];
    });

    try {
      final apiKey = RemoteConfigService.getAnthropicApiKey();

      if (apiKey.isEmpty) {
        setState(() => _generating = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('API key not configured'),
            backgroundColor: AppColors.passwordWeak,
          ),
        );
        return;
      }

      final response = await http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': apiKey,
              'anthropic-version': '2023-06-01',
              'anthropic-dangerous-direct-browser-calls': 'true',
            },
            body: jsonEncode({
              'model': 'claude-sonnet-4-20250514',
              'max_tokens': 1000,
              'messages': [
                {
                  'role': 'user',
                  'content':
                      'Give me a short and inspiring decoration description (2-3 sentences) for a $spaceName. ${_userStyles.isNotEmpty ? 'Consider ${_userStyles.join(', ')} styles.' : ''} ${_selectedPalette != null ? 'Use $_selectedPalette color palette.' : ''} Then give me 4 specific Unsplash search keywords (comma separated) to find images of this space. Format: DESCRIPTION: [text] | KEYWORDS: [kw1,kw2,kw3,kw4]',
                },
              ],
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timed out');
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['content'][0]['text'] as String;

        String description = '';
        List<String> keywords = [];

        if (text.contains('DESCRIPTION:') && text.contains('KEYWORDS:')) {
          final parts = text.split('|');
          description = parts[0].replaceAll('DESCRIPTION:', '').trim();
          final kwPart = parts[1].replaceAll('KEYWORDS:', '').trim();
          keywords = kwPart.split(',').map((k) => k.trim()).toList();
        } else {
          description = text;
          keywords = [
            '$spaceName interior design',
            '$spaceName decoration ideas',
            '$spaceName room design',
            'interior design $spaceName',
          ];
        }

        final images = <String>[];
        for (final kw in keywords.take(4)) {
          final query = Uri.encodeComponent(kw);
          images.add('https://source.unsplash.com/400x300/?$query');
        }

        setState(() {
          _aiDescription = description;
          _images = images;
          _generating = false;
        });
      } else {
        setState(() => _generating = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
            backgroundColor: AppColors.passwordWeak,
          ),
        );
      }
    } catch (e) {
      setState(() => _generating = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final categories = _getCategories(l);
    final palettes = _getPalettes();

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen capturada
                    if (widget.initialImage != null) ...[
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            widget.initialImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Mis Estilos
                    if (_userStyles.isNotEmpty) ...[
                      Text(
                        'Mis Estilos',
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _userStyles.map((style) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              style,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Paleta de colores
                    Text(
                      'Choose Color Palette',
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: palettes.map((palette) {
                          final isSelected = _selectedPalette == palette['key'];
                          final colors = palette['colors'] as List<Color>;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedPalette = palette['key']);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.15)
                                    : AppColors.surface(context),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.inputBorder(context),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: colors
                                        .map(
                                          (c) => Container(
                                            width: 14,
                                            height: 14,
                                            margin: const EdgeInsets.only(
                                              right: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: c,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white24,
                                                width: 0.5,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    palette['label'] as String,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary(context),
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      l.chooseSpace,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.chooseSpaceDesc,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Grid de categorías
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                      children: categories.entries.map((entry) {
                        final isSelected = _selectedCategory == entry.key;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = entry.key;
                              _selectedSpace = null;
                              _aiDescription = null;
                              _images = [];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.15)
                                  : AppColors.surface(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.inputBorder(context),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  entry.value['icon'] as String,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value['label'] as String,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary(context),
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Subespacios
                    if (_selectedCategory != null &&
                        _selectedCategory != 'custom') ...[
                      const SizedBox(height: 20),
                      Text(
                        'Select a room',
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            (categories[_selectedCategory]!['spaces'] as List)
                                .map((space) {
                                  final isSelected =
                                      _selectedSpace == space['label'];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedSpace = space['label'];
                                        _aiDescription = null;
                                        _images = [];
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary.withOpacity(
                                                0.15,
                                              )
                                            : AppColors.surface(context),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.inputBorder(context),
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            space['icon'] as String,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            space['label'] as String,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.textPrimary(
                                                      context,
                                                    ),
                                              fontSize: 12,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                      ),
                    ],

                    // Campo personalizado
                    if (_selectedCategory == 'custom') ...[
                      const SizedBox(height: 20),
                      Text(
                        l.spaceCustom,
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customController,
                        style: TextStyle(color: AppColors.textPrimary(context)),
                        decoration: InputDecoration(
                          hintText: l.spaceCustomHint,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary(context),
                          ),
                          filled: true,
                          fillColor: AppColors.surface(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Botón generar
                    if (_selectedCategory != null &&
                        (_selectedSpace != null ||
                            (_selectedCategory == 'custom' &&
                                _customController.text.trim().isNotEmpty))) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _generating ? null : _generateIdeas,
                          icon: _generating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 18,
                                ),
                          label: Text(
                            _generating ? l.generatingIdeas : l.generateIdeas,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],

                    // Resultados
                    if (_aiDescription != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _aiDescription!,
                                style: TextStyle(
                                  color: AppColors.textPrimary(context),
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${l.inspirationFor} ${_selectedSpace ?? _customController.text}',
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                        children: _images.map((url) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  color: AppColors.surface(context),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.surface(context),
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

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

  Widget _buildHeader(BuildContext context, S l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary(context),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Inspírate',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }
}
