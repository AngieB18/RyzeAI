// lib/home/screens/design_generator_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/core/services/remote_config_service.dart';
import 'package:ryzeai/generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';
import 'package:ryzeai/core/services/user_service.dart';

class DesignGeneratorScreen extends StatefulWidget {
  final File? initialImage;

  const DesignGeneratorScreen({super.key, this.initialImage});

  @override
  State<DesignGeneratorScreen> createState() => _DesignGeneratorScreenState();
}

class _DesignGeneratorScreenState extends State<DesignGeneratorScreen> {
  String? _selectedRoom;
  String? _selectedStyle;
  String? _selectedPalette;
  List<String> _selectedFeatures = [];
  bool _generating = false;
  File? _selectedImage;
  List<String> _userStyles = []; // User's pre-selected styles from home

  // Room types
  final List<Map<String, String>> _rooms = [
    {'key': 'living_room', 'label': 'Living Room'},
    {'key': 'bedroom', 'label': 'Bedroom'},
    {'key': 'kitchen', 'label': 'Kitchen'},
    {'key': 'bathroom', 'label': 'Bathroom'},
    {'key': 'office', 'label': 'Office'},
    {'key': 'dining_room', 'label': 'Dining Room'},
  ];

  // All styles
  final List<Map<String, String>> _styles = [
    {'key': 'modern'},
    {'key': 'minimal'},
    {'key': 'traditional'},
    {'key': 'japanese'},
    {'key': 'contemporary'},
    {'key': 'bohemian'},
    {'key': 'farmhouse'},
    {'key': 'vintage'},
    {'key': 'industrial'},
    {'key': 'retro'},
    {'key': 'cyberpunk'},
    {'key': 'christmas'},
    {'key': 'tropical'},
    {'key': 'scandinavian'},
    {'key': 'natural'},
    {'key': 'rustic'},
    {'key': 'colorful'},
    {'key': 'brutalist'},
    {'key': 'southwest'},
    {'key': 'baroque'},
    {'key': 'futuristic'},
    {'key': 'colonial'},
    {'key': 'rococo'},
    {'key': 'valentine'},
  ];

  // Color palettes
  final List<Map<String, dynamic>> _palettes = [
    {
      'key': 'neutral',
      'colors': [
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
        Color(0xFF9E9E9E),
        Color(0xFF616161),
      ],
    },
    {
      'key': 'warm',
      'colors': [
        Color(0xFFFFE0B2),
        Color(0xFFFFCC80),
        Color(0xFFFF8A65),
        Color(0xFFE64A19),
      ],
    },
    {
      'key': 'cool',
      'colors': [
        Color(0xFFE3F2FD),
        Color(0xFF90CAF9),
        Color(0xFF42A5F5),
        Color(0xFF1565C0),
      ],
    },
    {
      'key': 'earthy',
      'colors': [
        Color(0xFFEFEBE9),
        Color(0xFFBCAAA4),
        Color(0xFF8D6E63),
        Color(0xFF4E342E),
      ],
    },
    {
      'key': 'monochrome',
      'colors': [
        Color(0xFFFFFFFF),
        Color(0xFFBDBDBD),
        Color(0xFF616161),
        Color(0xFF212121),
      ],
    },
    {
      'key': 'vibrant',
      'colors': [
        Color(0xFFFF1744),
        Color(0xFFFF9100),
        Color(0xFF00E676),
        Color(0xFF2979FF),
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Load initial image if provided
    if (widget.initialImage != null) {
      _selectedImage = widget.initialImage;
    }
    _loadUserStyles();
  }

  Future<void> _loadUserStyles() async {
    try {
      final data = await UserService.getCurrentUserData();
      if (data != null && data['styles'] != null) {
        setState(() {
          _userStyles = List<String>.from(data['styles']);
        });
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<String> _imageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  String _getStyleLabel(S l, String key) {
    switch (key) {
      case 'modern':
        return l.styleModern;
      case 'natural':
        return l.styleNatural;
      case 'minimal':
        return l.styleMinimal;
      case 'colorful':
        return l.styleColorful;
      case 'rustic':
        return l.styleRustic;
      case 'scandinavian':
        return l.styleScandinavian;
      case 'traditional':
        return l.styleTraditional;
      case 'japanese':
        return l.styleJapanese;
      case 'contemporary':
        return l.styleContemporary;
      case 'bohemian':
        return l.styleBohemian;
      case 'farmhouse':
        return l.styleFarmhouse;
      case 'vintage':
        return l.styleVintage;
      case 'industrial':
        return l.styleIndustrial;
      case 'retro':
        return l.styleRetro;
      case 'cyberpunk':
        return l.styleCyberpunk;
      case 'christmas':
        return l.styleChristmas;
      case 'tropical':
        return l.styleTropical;
      case 'brutalist':
        return l.styleBrutalist;
      case 'southwest':
        return l.styleSouthwest;
      case 'baroque':
        return l.styleBaroque;
      case 'futuristic':
        return l.styleFuturistic;
      case 'colonial':
        return l.styleColonial;
      case 'rococo':
        return l.styleRococo;
      case 'valentine':
        return l.styleValentine;
      default:
        return key;
    }
  }

  String _getPaletteLabel(S l, String key) {
    switch (key) {
      case 'neutral':
        return l.colorPaletteNeutral;
      case 'warm':
        return l.colorPaletteWarm;
      case 'cool':
        return l.colorPaletteCool;
      case 'earthy':
        return l.colorPaletteEarthy;
      case 'monochrome':
        return l.colorPaletteMonochrome;
      case 'vibrant':
        return l.colorPaletteVibrant;
      default:
        return key;
    }
  }

  Future<void> _generate(S l) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
      return;
    }

    if (_selectedRoom == null) return;

    final stylesToGenerate = _userStyles.isNotEmpty
        ? _userStyles
        : (_selectedStyle != null ? [_selectedStyle!] : []);

    if (stylesToGenerate.isEmpty) return;

    setState(() => _generating = true);

    try {
      final apiKey = RemoteConfigService.getAnthropicApiKey();

      if (apiKey.isEmpty) {
        if (mounted) {
          setState(() => _generating = false);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('API key not configured'),
              backgroundColor: AppColors.passwordWeak,
            ),
          );
        }
        return;
      }

      final features = _selectedFeatures.isNotEmpty
          ? 'with features: ${_selectedFeatures.join(', ')}'
          : '';
      final palette = _selectedPalette != null
          ? 'color palette: $_selectedPalette'
          : '';

      final designs = <Map<String, String>>[];

      for (final style in stylesToGenerate) {
        String prompt;
        Map<String, dynamic>? messageContent;

        if (_selectedImage != null) {
          final base64Image = await _imageToBase64(_selectedImage!);

          prompt =
              'Looking at this room image, give 3 decoration ideas in $style style for $_selectedRoom $palette $features. '
              'Format: TITLE | DESC | KEYWORD separated by ---';

          messageContent = {
            'type': 'image',
            'source': {
              'type': 'base64',
              'media_type': 'image/jpeg',
              'data': base64Image,
            },
          };
        } else {
          prompt =
              'Give 3 decoration ideas for $_selectedRoom in $style style $palette $features. '
              'Format: TITLE | DESC | KEYWORD separated by ---';
        }

        final response = await http.post(
          Uri.parse('https://api.anthropic.com/v1/messages'),
          headers: {
            'Content-Type': 'application/json',
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
          },
          body: jsonEncode({
            'model': 'claude-sonnet-4-20250514',
            'max_tokens': 1500,
            'messages': [
              {
                'role': 'user',
                'content': _selectedImage != null
                    ? [
                        messageContent,
                        {'type': 'text', 'text': prompt},
                      ]
                    : prompt,
              },
            ],
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['content'][0]['text'] as String;

          final ideas = text.split('---');

          for (final idea in ideas) {
            final titleMatch = RegExp(
              r'TITLE:\s*(.+?)(?:\||$)',
            ).firstMatch(idea);
            final descMatch = RegExp(r'DESC:\s*(.+?)(?:\||$)').firstMatch(idea);
            final kwMatch = RegExp(r'KEYWORD:\s*(.+?)$').firstMatch(idea);

            final title = titleMatch?.group(1)?.trim() ?? '';
            final desc = descMatch?.group(1)?.trim() ?? '';
            final keyword = kwMatch?.group(1)?.trim() ?? '';

            if (title.isNotEmpty) {
              designs.add({
                'title': title,
                'description': desc,
                'imageUrl':
                    'https://source.unsplash.com/400x300/?${Uri.encodeComponent(keyword.isNotEmpty ? keyword : style)}',
                'room': _selectedRoom!,
                'style': style,
                'palette': _selectedPalette ?? '',
              });
            }
          }
        }
      }

      if (!mounted) return;

      setState(() => _generating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.savedToDesigns),
          backgroundColor: AppColors.passwordStrong,
        ),
      );

      final supabase = Supabase.instance.client;

      for (final design in designs) {
        await supabase.from('my_designs').insert({
          'user_id': user.id,
          'image_url': design['imageUrl'],
          'title': design['title'],
          'style': design['style'],
          'room': design['room'],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      setState(() => _generating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.passwordWeak,
        ),
      );
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selecciona una opción',
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 20),
                label: const Text(
                  'Tomar foto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.image_rounded, size: 20),
                label: const Text(
                  'Cargar imagen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.passwordWeak,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _selectedImage = null);
                    },
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text(
                      'Eliminar imagen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

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
                    // Image picker
                    _buildImagePicker(context, l),
                    const SizedBox(height: 20),

                    // Room type
                    _buildSectionHeader(context, l.chooseRoomType, true, l),
                    const SizedBox(height: 10),
                    _buildRoomSelector(context, l),
                    const SizedBox(height: 20),

                    // Style
                    _buildSectionHeader(context, l.chooseStyle, true, l),
                    const SizedBox(height: 10),
                    _userStyles.isNotEmpty
                        ? _buildUserStylesDisplay(context, l)
                        : _buildStyleSelector(context, l),
                    const SizedBox(height: 20),

                    // Color palette
                    _buildSectionHeader(
                      context,
                      l.chooseColorPalette,
                      false,
                      l,
                    ),
                    const SizedBox(height: 10),
                    _buildPaletteSelector(context, l),
                    const SizedBox(height: 20),

                    // Features
                    _buildSectionHeader(context, l.addFeatures, false, l),
                    const SizedBox(height: 10),
                    _buildFeaturesSelector(context, l),
                    const SizedBox(height: 30),

                    // Generate button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _selectedRoom == null ||
                                  (_userStyles.isEmpty &&
                                      _selectedStyle == null)
                              ? AppColors.inputBorder(context)
                              : AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed:
                            _selectedRoom == null ||
                                (_userStyles.isEmpty &&
                                    _selectedStyle == null) ||
                                _generating
                            ? null
                            : () => _generate(l),
                        icon: _generating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 20,
                              ),
                        label: Text(
                          _generating ? l.generatingDesign : l.generateDesign,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildHeader(BuildContext context, S l) {
    return AppHeader(
      title: l.generateDesign,
      onBack: () => Navigator.pop(context),
    );
  }

  Widget _buildImagePicker(BuildContext context, S l) {
    return ImagePickerDisplay(
      selectedImage: _selectedImage,
      onTap: _showImagePickerOptions,
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    bool required,
    S l,
  ) {
    return SectionHeader(
      title: title,
      required: required,
      badge: required ? l.required : l.optional,
    );
  }

  Widget _buildRoomSelector(BuildContext context, S l) {
    return RoomSelector(
      rooms: _rooms,
      selectedRoom: _selectedRoom,
      onRoomSelected: (room) => setState(() => _selectedRoom = room),
    );
  }

  Widget _buildStyleSelector(BuildContext context, S l) {
    return StyleSelector(
      styles: _styles,
      selectedStyle: _selectedStyle,
      onStyleSelected: (style) {
        setState(() => _selectedStyle = style);
        if (style != null) {
          UserService.updateUserStyles([style]);
        }
      },
      getStyleLabel: (key, _) => _getStyleLabel(l, key),
    );
  }

  Widget _buildUserStylesDisplay(BuildContext context, S l) {
    return UserStylesDisplay(
      userStyles: _userStyles,
      allStyles: _styles,
      getStyleLabel: (style) => _getStyleLabel(l, style),
    );
  }

  Widget _buildPaletteSelector(BuildContext context, S l) {
    return ColorPaletteSelector(
      palettes: _palettes,
      selectedPalette: _selectedPalette,
      onPaletteSelected: (palette) =>
          setState(() => _selectedPalette = palette),
      getPaletteLabel: (key) => _getPaletteLabel(l, key),
    );
  }

  Widget _buildFeaturesSelector(BuildContext context, S l) {
    final sections = [
      {
        'title': l.lighting,
        'color': const Color(0xFFE8A020),
        'features': [
          {'key': 'ambient_light', 'label': l.ambientLight},
          {'key': 'natural_light', 'label': l.naturalLight},
          {'key': 'cozy_atmosphere', 'label': l.cozyAtmosphere},
        ],
      },
      {
        'title': l.architecture,
        'color': const Color(0xFF7B68EE),
        'features': [
          {'key': 'accent_wall', 'label': l.accentWall},
          {'key': 'built_in_shelves', 'label': l.builtInShelves},
          {'key': 'exposed_beams', 'label': l.exposedBeams},
          {'key': 'arches', 'label': l.arches},
        ],
      },
      {
        'title': l.decoration,
        'color': const Color(0xFF20B2AA),
        'features': [
          {'key': 'plants', 'label': l.plants},
          {'key': 'mirrors', 'label': l.mirrors},
          {'key': 'textured_walls', 'label': l.texturedWalls},
          {'key': 'rugs', 'label': l.rugs},
        ],
      },
    ];

    return EmojiFeatureSelector(
      sections: sections,
      selectedFeatures: _selectedFeatures,
      onFeatureToggled: (feature, isSelected) {
        setState(() {
          if (isSelected) {
            _selectedFeatures.add(feature);
          } else {
            _selectedFeatures.remove(feature);
          }
        });
      },
    );
  }
}
