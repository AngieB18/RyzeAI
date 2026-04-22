import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/generated/l10n.dart';
import 'package:ryzeai/main.dart';
import 'package:ryzeai/presentation/features/favorites/screens/favorites_screen.dart';
import 'package:ryzeai/presentation/features/home/screens/home_screen.dart';
import 'package:ryzeai/presentation/features/profile/screens/profile_screen.dart';
import 'package:ryzeai/presentation/features/projects/screens/projects_screen.dart';
import '../widgets/widgets_home_page.dart';
import 'package:ryzeai/presentation/features/camera/screens/image_action_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),      // index 0
    FavoritesScreen(), // index 1
    ProjectsScreen(),  // index 2
    ProfileScreen(),   // index 3
  ];

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => HomeImagePickerSheet(
        onCameraTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.camera);
        },
        onGalleryTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.gallery);
        },
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
            builder: (_) => ImageActionScreen(image: imageFile),
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
    final translations = S.of(context);

    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background(context),
          body: _screens[_currentIndex],
          bottomNavigationBar: HomeBottomNav(
            translations: translations,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
          floatingActionButton: HomeCameraFAB(
            onTap: _showImagePickerOptions,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}