import 'package:flutter/material.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/styles/style_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../widgets/widgets_style_selection_sheet.dart';

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
  List<Map<String, dynamic>> _styles = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.initialSelected);
    _loadStyles();
  }

  Future<void> _loadStyles() async {
    final styles = await StyleService.getStyles();

    setState(() {
      _styles = styles;
      _loading = false;
    });
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else if (_selected.length < 4) {
        _selected.add(id);
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    await UserService.updateUserStyles(_selected);

    if (!mounted) return;
    Navigator.pop(context);
    widget.onSaved?.call();
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
            // HANDLE
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      children: [
                        // LOGO
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 213, 178),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: Image.asset(
                              'assets/LogoRyzeAI.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

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

                        /// 🔥 AQUÍ USAS TU WIDGET LIMPIO
                        StylesGrid(
                          styles: _styles,
                          selected: _selected,
                          onToggle: _toggle,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
            ),

            // BOTÓN
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selected.isEmpty
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.primary,

                      foregroundColor: Colors.black, // 👈 AQUÍ LA MAGIA
                    ),
                    onPressed: _selected.isEmpty || _saving ? null : _save,
                    child: _saving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l.continueButton),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
