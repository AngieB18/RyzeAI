// lib/home/screens/design_generator_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/core/services/remote_config_service.dart';
import 'package:ryzeai/generated/l10n.dart';

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
    {'key': 'living_room', 'label': 'Living Room', 'icon': '🛋️'},
    {'key': 'bedroom', 'label': 'Bedroom', 'icon': '🛏️'},
    {'key': 'kitchen', 'label': 'Kitchen', 'icon': '🍳'},
    {'key': 'bathroom', 'label': 'Bathroom', 'icon': '🚿'},
    {'key': 'office', 'label': 'Office', 'icon': '💼'},
    {'key': 'dining_room', 'label': 'Dining Room', 'icon': '🍽️'},
  ];

  // All styles
  final List<Map<String, String>> _styles = [
    {'key': 'modern', 'icon': '🏙️'},
    {'key': 'minimal', 'icon': '🕯️'},
    {'key': 'traditional', 'icon': '🏛️'},
    {'key': 'japanese', 'icon': '⛩️'},
    {'key': 'contemporary', 'icon': '🔷'},
    {'key': 'bohemian', 'icon': '🪬'},
    {'key': 'farmhouse', 'icon': '🌾'},
    {'key': 'vintage', 'icon': '📻'},
    {'key': 'industrial', 'icon': '⚙️'},
    {'key': 'retro', 'icon': '🕹️'},
    {'key': 'cyberpunk', 'icon': '🤖'},
    {'key': 'christmas', 'icon': '🎄'},
    {'key': 'tropical', 'icon': '🌴'},
    {'key': 'scandinavian', 'icon': '❄️'},
    {'key': 'natural', 'icon': '🌿'},
    {'key': 'rustic', 'icon': '🪵'},
    {'key': 'colorful', 'icon': '🎨'},
    {'key': 'brutalist', 'icon': '🧱'},
    {'key': 'southwest', 'icon': '🌵'},
    {'key': 'baroque', 'icon': '👑'},
    {'key': 'futuristic', 'icon': '🚀'},
    {'key': 'colonial', 'icon': '🏚️'},
    {'key': 'rococo', 'icon': '🌸'},
    {'key': 'valentine', 'icon': '💝'},
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
      // Silently fail, user can still select a style manually
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
    if (_selectedRoom == null) return;

    // Use user's selected styles if loading is done, otherwise use selected single style
    final stylesToGenerate = _userStyles.isNotEmpty
        ? _userStyles
        : (_selectedStyle != null ? [_selectedStyle!] : []);
    if (stylesToGenerate.isEmpty) return;

    setState(() => _generating = true);

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

      final features = _selectedFeatures.isNotEmpty
          ? 'with features: ${_selectedFeatures.join(', ')}'
          : '';
      final palette = _selectedPalette != null
          ? 'color palette: $_selectedPalette'
          : '';

      final designs = <Map<String, String>>[];

      // Generate designs for each style
      for (final style in stylesToGenerate) {
        String prompt = '';
        Map<String, dynamic> messageContent = {};

        if (_selectedImage != null) {
          // Use vision API with image
          final base64Image = await _imageToBase64(_selectedImage!);
          prompt =
              'Looking at this room image, give me 3 inspiring decoration ideas in $style style for this $_selectedRoom $palette $features. Based on what you see in the image, suggest designs that enhance or transform it with the $style aesthetic. For each idea give: a title, a 2-sentence description, and 1 Unsplash search keyword. Format each as: TITLE: [title] | DESC: [description] | KEYWORD: [keyword]. Separate ideas with ---';

          messageContent = {
            'type': 'image',
            'source': {
              'type': 'base64',
              'media_type': 'image/jpeg',
              'data': base64Image,
            },
          };
        } else {
          // Use text-only prompt
          prompt =
              'Give me 3 inspiring decoration ideas for a $_selectedRoom with $style style $palette $features. For each idea give: a title, a 2-sentence description, and 1 Unsplash search keyword. Format each as: TITLE: [title] | DESC: [description] | KEYWORD: [keyword]. Separate ideas with ---';
        }

        final content = _selectedImage != null
            ? [
                messageContent,
                {'type': 'text', 'text': prompt},
              ]
            : prompt;

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
                'max_tokens': 1500,
                'messages': [
                  {
                    'role': 'user',
                    'content': _selectedImage != null ? content : prompt,
                  },
                ],
              }),
            )
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final text = data['content'][0]['text'] as String;

          final ideas = text
              .split('---')
              .where((s) => s.trim().isNotEmpty)
              .toList();

          for (final idea in ideas) {
            String title = '';
            String desc = '';
            String keyword = '';

            if (idea.contains('TITLE:')) {
              final titleMatch = RegExp(
                r'TITLE:\s*(.+?)(?:\||\n|$)',
              ).firstMatch(idea);
              final descMatch = RegExp(
                r'DESC:\s*(.+?)(?:\|KEYWORD|$)',
                dotAll: true,
              ).firstMatch(idea);
              final kwMatch = RegExp(
                r'KEYWORD:\s*(.+?)(?:\n|$)',
              ).firstMatch(idea);

              title = titleMatch?.group(1)?.trim() ?? '';
              desc = descMatch?.group(1)?.trim() ?? '';
              keyword = kwMatch?.group(1)?.trim() ?? '';
            }

            if (title.isNotEmpty) {
              designs.add({
                'title': title,
                'description': desc,
                'imageUrl':
                    'https://source.unsplash.com/400x300/?${Uri.encodeComponent(keyword.isNotEmpty ? keyword : '$style $_selectedRoom')}',
                'room': _selectedRoom!,
                'style': style,
                'palette': _selectedPalette ?? '',
              });
            }
          }
        }
      }

      // Guardar en Firestore
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null && designs.isNotEmpty) {
        for (final design in designs) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('my_designs')
              .add({...design, 'createdAt': FieldValue.serverTimestamp()});
        }
      }

      setState(() => _generating = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.savedToDesigns),
          backgroundColor: AppColors.passwordStrong,
        ),
      );

      Navigator.pop(context);
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
            l.generateDesign,
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

  Widget _buildImagePicker(BuildContext context, S l) {
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _selectedImage != null
              ? AppColors.surface(context)
              : AppColors.inputBorder(context).withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedImage != null
                ? AppColors.primary
                : AppColors.inputBorder(context),
            width: 2,
          ),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _selectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.image_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Cargar imagen',
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toma una foto o carga una imagen JPG/PNG',
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    bool required,
    S l,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: required
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.inputBorder(context).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            required ? l.required : l.optional,
            style: TextStyle(
              color: required
                  ? AppColors.primary
                  : AppColors.textSecondary(context),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomSelector(BuildContext context, S l) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _rooms.map((room) {
          final isSelected = _selectedRoom == room['key'];
          return GestureDetector(
            onTap: () => setState(() => _selectedRoom = room['key']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
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
                  Text(room['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    room['label']!,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary(context),
                      fontSize: 13,
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
    );
  }

  Widget _buildStyleSelector(BuildContext context, S l) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _styles.map((style) {
        final isSelected = _selectedStyle == style['key'];
        final label = _getStyleLabel(l, style['key']!);
        return GestureDetector(
          onTap: () => setState(() => _selectedStyle = style['key']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
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
                Text(style['icon']!, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary(context),
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUserStylesDisplay(BuildContext context, S l) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _userStyles.map((style) {
        final styleData = _styles.firstWhere(
          (s) => s['key'] == style,
          orElse: () => {'key': style, 'icon': '🎨'},
        );
        final label = _getStyleLabel(l, style);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(styleData['icon']!, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 14,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaletteSelector(BuildContext context, S l) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _palettes.map((palette) {
          final isSelected = _selectedPalette == palette['key'];
          final label = _getPaletteLabel(l, palette['key'] as String);
          final colors = palette['colors'] as List<Color>;
          return GestureDetector(
            onTap: () =>
                setState(() => _selectedPalette = palette['key'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(12),
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
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: colors
                        .map(
                          (c) => Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 2),
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
                  const SizedBox(height: 6),
                  Text(
                    label,
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
    );
  }

  Widget _buildFeaturesSelector(BuildContext context, S l) {
    final sections = [
      {
        'title': l.lighting,
        'color': const Color(0xFFE8A020),
        'features': [l.ambientLight, l.naturalLight, l.cozyAtmosphere],
      },
      {
        'title': l.architecture,
        'color': const Color(0xFF7B68EE),
        'features': [l.accentWall, l.builtInShelves, l.exposedBeams, l.arches],
      },
      {
        'title': l.decoration,
        'color': const Color(0xFF20B2AA),
        'features': [l.plants, l.mirrors, l.texturedWalls, l.rugs],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        final color = section['color'] as Color;
        final features = section['features'] as List<String>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                section['title'] as String,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features.map((feature) {
                final isSelected = _selectedFeatures.contains(feature);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFeatures.remove(feature);
                      } else {
                        _selectedFeatures.add(feature);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.15)
                          : AppColors.surface(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? color
                            : AppColors.inputBorder(context),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: isSelected
                            ? color
                            : AppColors.textPrimary(context),
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
}
