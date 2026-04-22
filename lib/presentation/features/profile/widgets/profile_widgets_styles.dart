import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../styles/screens/style_selection_sheet.dart';

class ProfileWidgetsStyles extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final VoidCallback onRefresh;

  const ProfileWidgetsStyles({
    super.key,
    required this.userData,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final styles = List<String>.from(userData?['styles'] ?? []);

    final styleData = {
      'modern': {'icon': '🏠', 'label': l.styleModern},
      'natural': {'icon': '🌿', 'label': l.styleNatural},
      'minimal': {'icon': '🕯️', 'label': l.styleMinimal},
      'colorful': {'icon': '🎨', 'label': l.styleColorful},
      'rustic': {'icon': '🪵', 'label': l.styleRustic},
      'scandinavian': {'icon': '❄️', 'label': l.styleScandinavian},
      'traditional': {'icon': '🏛️', 'label': l.styleTraditional},
      'japanese': {'icon': '🎌', 'label': l.styleJapanese},
      'contemporary': {'icon': '⚡', 'label': l.styleContemporary},
      'bohemian': {'icon': '🌸', 'label': l.styleBohemian},
      'farmhouse': {'icon': '🚜', 'label': l.styleFarmhouse},
      'vintage': {'icon': '📻', 'label': l.styleVintage},
      'industrial': {'icon': '🔧', 'label': l.styleIndustrial},
      'retro': {'icon': '🎪', 'label': l.styleRetro},
      'cyberpunk': {'icon': '🤖', 'label': l.styleCyberpunk},
      'christmas': {'icon': '🎄', 'label': l.styleChristmas},
      'tropical': {'icon': '🌴', 'label': l.styleTropical},
      'brutalist': {'icon': '🧱', 'label': l.styleBrutalist},
      'southwest': {'icon': '🌞', 'label': l.styleSouthwest},
      'baroque': {'icon': '👑', 'label': l.styleBaroque},
      'futuristic': {'icon': '🚀', 'label': l.styleFuturistic},
      'colonial': {'icon': '🏰', 'label': l.styleColonial},
      'rococo': {'icon': '💎', 'label': l.styleRococo},
      'valentine': {'icon': '💝', 'label': l.styleValentine},
    };

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
                      initialSelected: styles,
                      onSaved: onRefresh,
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
          styles.isEmpty
              ? Text(
                  l.noStylesSelected,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 12,
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: styles.map((key) {
                    final data = styleData[key];
                    if (data == null) return const SizedBox();
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
                            data['icon']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            data['label']!,
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
