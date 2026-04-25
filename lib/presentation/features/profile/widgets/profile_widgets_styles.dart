import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../styles/screens/style_selection_sheet.dart';

class ProfileWidgetsStyles extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback onRefresh;

  const ProfileWidgetsStyles({
    super.key,
    required this.userData,
    required this.onRefresh,
  });

  @override
  State<ProfileWidgetsStyles> createState() =>
      _ProfileWidgetsStylesState();
}

class _ProfileWidgetsStylesState
    extends State<ProfileWidgetsStyles> {
  List<Map<String, dynamic>> _styles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStyles();
  }

  @override
  void didUpdateWidget(covariant ProfileWidgetsStyles oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userData?['styles'] != widget.userData?['styles']) {
      _loadStyles();
    }
  }

  Future<void> _loadStyles() async {
    final ids = List<String>.from(widget.userData?['styles'] ?? []);

    if (ids.isEmpty) {
      setState(() {
        _styles = [];
        _loading = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('styles')
          .select()
          .inFilter('id', ids);

      setState(() {
        _styles = List<Map<String, dynamic>>.from(response);
        _loading = false;
      });
    } catch (e) {
      print('Error cargando styles: $e');
      setState(() => _loading = false);
    }
  }

  String _getLabel(Map<String, dynamic>? nameJson) {
    if (nameJson == null) return '';

    final locale = Localizations.localeOf(context).languageCode;
    return nameJson[locale] ?? nameJson['en'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final selectedIds =
        List<String>.from(widget.userData?['styles'] ?? []);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.myStyles,
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => StyleSelectionSheet(
                      initialSelected: selectedIds,
                      onSaved: widget.onRefresh,
                    ),
                  );
                },
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// LOADING
          if (_loading)
            const Center(child: CircularProgressIndicator())

          /// EMPTY
          else if (_styles.isEmpty)
            Text(
              l.noStylesSelected,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 12,
              ),
            )

          /// LISTA REAL DESDE DB
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _styles.map((style) {
                final label = _getLabel(style['name']);
                final icon = style['icon'] ?? '🎨';

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        icon,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}