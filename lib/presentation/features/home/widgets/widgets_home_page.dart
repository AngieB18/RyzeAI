import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';

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
  final IconData icon;
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
            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : AppColors.textSecondary(context),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary(context),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// BottomAppBar completo con todos los tabs
// ─────────────────────────────────────────
class HomeBottomNav extends StatelessWidget {
  final S translations;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.translations,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeNavItem(
              index: 0,
              currentIndex: currentIndex,
              icon: Icons.home_rounded,
              label: translations.home,
              onTap: onTap,
            ),
            HomeNavItem(
              index: 1,
              currentIndex: currentIndex,
              icon: Icons.favorite_rounded,
              label: translations.favorites,
              onTap: onTap,
            ),
            const SizedBox(width: 58), // espacio para el FAB
            HomeNavItem(
              index: 2,
              currentIndex: currentIndex,
              icon: Icons.folder_rounded,
              label: translations.projects,
              onTap: onTap,
            ),
            HomeNavItem(
              index: 4,
              currentIndex: currentIndex,
              icon: Icons.palette_rounded,
              label: 'Diseños',
              onTap: onTap,
            ),
            HomeNavItem(
              index: 3,
              currentIndex: currentIndex,
              icon: Icons.person_rounded,
              label: translations.profile,
              onTap: onTap,
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
            'Selecciona una opción',
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Botón cámara
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

          // Botón galería
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
        ],
      ),
    );
  }
}