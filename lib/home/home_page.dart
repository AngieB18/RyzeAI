import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../generated/l10n.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/profile_screen.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoritesScreen(),
    ProjectsScreen(),
    ProfileScreen(),
  ];

  void _onCameraPressed() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.camera_alt_rounded,
              color: AppColors.primary,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'AI Camera',
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Point your camera at any space and\nvisualize furniture in 3D instantly',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Open Camera',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background(context),

          // 🔥 YA SIN SELECTOR DE IDIOMA
          body: _screens[_currentIndex],

          bottomNavigationBar: _buildBottomNav(l),
          floatingActionButton: _buildCameraFAB(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget _buildCameraFAB() {
    return GestureDetector(
      onTap: _onCameraPressed,
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

  Widget _buildBottomNav(S l) {
    return BottomAppBar(
      color: AppColors.surface(context),
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, l.home),
            _buildNavItem(1, Icons.favorite_rounded, l.favorites),
            const SizedBox(width: 58),
            _buildNavItem(2, Icons.folder_rounded, l.projects),
            _buildNavItem(3, Icons.person_rounded, l.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
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
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}