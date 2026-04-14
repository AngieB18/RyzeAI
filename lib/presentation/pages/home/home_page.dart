import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/generated/l10n.dart';
import 'package:ryzeai/main.dart';
import 'package:ryzeai/presentation/pages/home/favorites_screen.dart';
import 'dart:io';

import 'package:ryzeai/presentation/pages/home/home_screen.dart';
import 'package:ryzeai/presentation/pages/home/my_designs_screen.dart';
import 'package:ryzeai/presentation/pages/home/profile_screen.dart';
import 'package:ryzeai/presentation/pages/home/projects_screen.dart';
import 'package:ryzeai/presentation/pages/home/style_inspiration_screen.dart';

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
    MyDesignsScreen(),
  ];

  void _onCameraPressed() {
    _showImagePickerOptions();
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
          ],
        ),
      ),
    );
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
        final imageFile = File(image.path);
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StyleInspirationScreen(initialImage: imageFile),
          ),
        );
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
          border: Border.all(color: AppColors.background(context), width: 3),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_rounded, l.home),
            _buildNavItem(1, Icons.favorite_rounded, l.favorites),
            const SizedBox(width: 58),
            _buildNavItem(2, Icons.folder_rounded, l.projects),
            _buildNavItem(4, Icons.palette_rounded, 'Diseños'),
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
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
