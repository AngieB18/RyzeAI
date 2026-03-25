// lib/home/screens/style_selection_sheet.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../generated/l10n.dart';

class StyleSelectionSheet extends StatefulWidget {
  final List<String> initialSelected;
  final VoidCallback? onSaved;

  const StyleSelectionSheet({
    super.key,
    this.initialSelected = const [],
    this.onSaved,
  });

  @override
  State<StyleSelectionSheet> createState() => _StyleSelectionSheetState();
}

class _StyleSelectionSheetState extends State<StyleSelectionSheet> {
  late List<String> _selected;
  bool _saving = false;

  final List<Map<String, String>> _styles = [
    {'key': 'modern', 'icon': '🏠'},
    {'key': 'natural', 'icon': '🌿'},
    {'key': 'minimal', 'icon': '🕯️'},
    {'key': 'colorful', 'icon': '🎨'},
    {'key': 'rustic', 'icon': '🪵'},
    {'key': 'scandinavian', 'icon': '❄️'},
    {'key': 'traditional', 'icon': '🏛️'},
    {'key': 'japanese', 'icon': '🎌'},
    {'key': 'contemporary', 'icon': '⚡'},
    {'key': 'bohemian', 'icon': '🌸'},
    {'key': 'farmhouse', 'icon': '🚜'},
    {'key': 'vintage', 'icon': '📻'},
    {'key': 'industrial', 'icon': '🔧'},
    {'key': 'retro', 'icon': '🎪'},
    {'key': 'cyberpunk', 'icon': '🤖'},
    {'key': 'christmas', 'icon': '🎄'},
    {'key': 'tropical', 'icon': '🌴'},
    {'key': 'brutalist', 'icon': '🧱'},
    {'key': 'southwest', 'icon': '🌞'},
    {'key': 'baroque', 'icon': '👑'},
    {'key': 'futuristic', 'icon': '🚀'},
    {'key': 'colonial', 'icon': '🏰'},
    {'key': 'rococo', 'icon': '💎'},
    {'key': 'valentine', 'icon': '💝'},
  ];

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
  }

  String _getStyleLabel(BuildContext context, String key) {
    final l = S.of(context);
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

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'styles': _selected,
          'stylesSelected': true,
        });
      }
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSaved?.call();
    } catch (e) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.85,
      expand: false,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.inputBorder(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                children: [
                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 213, 178),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Image.asset(
                        'assets/LogoRyzeAI.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Título
                  Text(
                    l.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.selectStylesHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Máximo 4 estilos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid de estilos
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    children: _styles.map((style) {
                      final key = style['key']!;
                      final icon = style['icon']!;
                      final isSelected = _selected.contains(key);
                      final label = _getStyleLabel(context, key);
                      final maxReached = _selected.length >= 4 && !isSelected;

                      return GestureDetector(
                        onTap: maxReached
                            ? null
                            : () {
                                setState(() {
                                  if (isSelected) {
                                    _selected.remove(key);
                                  } else if (_selected.length < 4) {
                                    _selected.add(key);
                                  }
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.15)
                                : maxReached
                                    ? AppColors.background(context)
                                        .withOpacity(0.5)
                                    : AppColors.background(context),
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
                              Opacity(
                                opacity: maxReached ? 0.5 : 1.0,
                                child: Text(
                                  icon,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Opacity(
                                opacity: maxReached ? 0.5 : 1.0,
                                child: Text(
                                  label,
                                  textAlign: TextAlign.center,
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
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 12,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Botón continuar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selected.isEmpty
                            ? AppColors.inputBorder(context)
                            : AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _selected.isEmpty || _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l.continueButton,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
