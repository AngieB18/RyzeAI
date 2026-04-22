// lib/presentation/features/home/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../../core/services/user_service.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../main.dart';
import '../../styles/screens/style_selection_sheet.dart';
import '../widgets/widgets_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    themeProvider.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  Future<void> _loadUser() async {
    final data = await UserService.getCurrentUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _loading = false;
      });

      final stylesSelected = data?['styles_selected'] ?? false;
      if (!stylesSelected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showStyleSheet();
        });
      }
    }
  }

  void _showStyleSheet() {
    final currentStyles = List<String>.from(_userData?['styles'] ?? []);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => StyleSelectionSheet(
        initialSelected: currentStyles,
        onSaved: () => _loadUser(),
      ),
    );
  }

  // La lógica de cámara vive en HomePage (FAB)
  // El banner solo dispara el callback que viene del padre
  // Si quieres que el banner también abra la cámara,
  // pasa el callback desde HomePage via constructor

  @override
  Widget build(BuildContext context) {
    final translations = S.of(context);

    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName  = _userData?['lastName']  ?? _userData?['last_name']  ?? '';
    final initials  = UserService.getInitials(firstName, lastName);
    final photoUrl  = _userData?['photoUrl'] as String?;

    // Construir ImageProvider según el tipo de URL
    ImageProvider? imageProvider;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('data:image')) {
        final base64Data = photoUrl.split(',').last;
        imageProvider = MemoryImage(base64Decode(base64Data));
      } else {
        imageProvider = NetworkImage(photoUrl);
      }
    }

    final userStyles = List<String>.from(_userData?['styles'] ?? []);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 👤 Header con saludo y avatar
            HomeHeader(
              translations: translations,
              firstName: firstName,
              initials: initials,
              imageProvider: imageProvider,
              loading: _loading,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Banner IA — el onCameraTap lo maneja el FAB de HomePage
                  // Si quieres que el banner también abra la cámara,
                  // convierte HomeScreen en un widget que reciba el callback
                  HomeAIBanner(
                    translations: translations,
                    onCameraTap: () {
                      // TODO: conectar con el FAB de HomePage via callback
                    },
                  ),

                  const SizedBox(height: 16),

                  // Estadísticas
                  Row(
                    children: [
                      Expanded(
                        child: HomeStatCard(
                          title: translations.projects,
                          value: '3',
                          subtitle: translations.thisMonth,
                          subtitleColor: AppColors.passwordStrong,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: HomeStatCard(
                          title: translations.favorites,
                          value: '12',
                          subtitle: translations.newItems,
                          subtitleColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Proyectos recientes
                  HomeSectionTitle(title: translations.recentProjects),
                  const SizedBox(height: 10),
                  HomeProjectItem(
                    icon: '🛋️',
                    name: translations.livingRoom,
                    time: '${translations.modifiedAgo} ${translations.hoursAgo}',
                    statusColor: AppColors.passwordStrong,
                  ),
                  HomeProjectItem(
                    icon: '🛏️',
                    name: translations.bedroom,
                    time: '${translations.modifiedAgo} ${translations.yesterday}',
                    statusColor: AppColors.passwordMedium,
                  ),

                  const SizedBox(height: 20),

                  // Mis estilos — título con botón editar
                  // HomeStylesSectionTitle(
                  //   title: userStyles.isEmpty
                  //       ? translations.exploreStyles
                  //       : translations.myStyles,
                  //   onEditTap: () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       isScrollControlled: true,
                  //       backgroundColor: Colors.transparent,
                  //       builder: (_) => StyleSelectionSheet(
                  //         initialSelected: userStyles,
                  //         onSaved: _loadUser,
                  //       ),
                  //     );
                  //   },
                  // ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}