import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/features/home/widgets/widgets_home_icons.dart';

// ─────────────────────────────────────────
// FAB central (botón cámara)
// ─────────────────────────────────────────
class HomeCameraFAB extends StatelessWidget {
  final VoidCallback onTap;

  const HomeCameraFAB({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.background(context),
            width: 3,
          ),
        ),
        child: const Icon(
          Icons.camera_alt_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Item individual del BottomNav
// ─────────────────────────────────────────
class HomeNavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final Widget icon;
  final String label;
  final ValueChanged<int> onTap;

  const HomeNavItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary(context),
                size: 22,
              ),
              child: icon,
            ),
            const SizedBox(height: 3),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary(context),
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// BottomAppBar: 2 | FAB | 2
// ─────────────────────────────────────────
class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.surface(context),
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            // ── Izquierda: Inicio + Publicaciones ──
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: HomeNavItem(
                      index: 0,
                      currentIndex: currentIndex,
                      icon: const Icon(Icons.home_rounded),
                      label: S.of(context).home,
                      onTap: onTap,
                    ),
                  ),
                  Expanded(
                    child: HomeNavItem(
                      index: 1,
                      currentIndex: currentIndex,
                      icon: const HomePublicationIcon(),
                      label: S.of(context).publications,
                      onTap: onTap,
                    ),
                  ),
                ],
              ),
            ),

            // ── Espacio FAB ──
            const SizedBox(width: 72),

            // ── Derecha: Proyectos + Perfil ──
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: HomeNavItem(
                      index: 2,
                      currentIndex: currentIndex,
                      icon: const Icon(Icons.folder_rounded),
                      label: S.of(context).projects,
                      onTap: onTap,
                    ),
                  ),
                  Expanded(
                    child: HomeNavItem(
                      index: 3,
                      currentIndex: currentIndex,
                      icon: const Icon(Icons.person_rounded),
                      label: S.of(context).profile,
                      onTap: onTap,
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

// ─────────────────────────────────────────
// BottomSheet para elegir cámara o galería
// ─────────────────────────────────────────
class HomeImagePickerSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const HomeImagePickerSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).selectOption,
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
              onPressed: onCameraTap,
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: Text(
                S.of(context).takePhoto,
                style: const TextStyle(
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
              onPressed: onGalleryTap,
              icon: const Icon(Icons.image_rounded, size: 20),
              label: Text(
                S.of(context).uploadImage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}