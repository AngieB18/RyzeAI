// lib/presentation/features/home/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../../core/services/user_service.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../main.dart';
import '../../styles/screens/style_selection_sheet.dart';
import '../widgets/widgets_home_screen.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../camera/screens/image_action_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;

  Map<String, dynamic>? _userData;
  bool _loading = true;

  List<Map<String, dynamic>> _recentProjects = [];
  int _projectCount = 0;
  int _favoriteCount = 0;
  int _projectsThisMonth = 0;
  int _newFavoritesThisMonth = 0;
  bool _loadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadStats();
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

  Future<void> _loadStats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final projects = await _supabase
          .from('projects')
          .select('id, user_id, name, room, status, created_at, updated_at, is_favorite')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final allProjects = List<Map<String, dynamic>>.from(projects);

      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      int projectsThisMonth = 0;
      int newFavoritesThisMonth = 0;

      for (final p in allProjects) {
        final createdAt = _parseSupabaseDate(p['created_at']);
        final updatedAt = _parseSupabaseDate(p['updated_at']);
        final isFavorite = p['is_favorite'] == true;

        if (createdAt != null && !createdAt.isBefore(startOfMonth)) {
          projectsThisMonth++;
        }

        final favDate = updatedAt ?? createdAt;
        if (isFavorite && favDate != null && !favDate.isBefore(startOfMonth)) {
          newFavoritesThisMonth++;
        }
      }

      final favorites = allProjects.where((p) => p['is_favorite'] == true).toList();

      if (mounted) {
        setState(() {
          _projectCount = allProjects.length;
          _favoriteCount = favorites.length;
          _recentProjects = allProjects.take(2).toList();
          _projectsThisMonth = projectsThisMonth;
          _newFavoritesThisMonth = newFavoritesThisMonth;
          _loadingStats = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando stats: $e');
      if (mounted) setState(() => _loadingStats = false);
    }
  }

  DateTime? _parseSupabaseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toLocal();
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toLocal();
    }
    return null;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.passwordStrong;
      case 'in progress':
        return AppColors.passwordMedium;
      default:
        return AppColors.darkTextSecondary;
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
      if (diff.inDays == 1) return 'Ayer';
      return 'Hace ${diff.inDays} días';
    } catch (_) {
      return isoDate;
    }
  }

  // Subtitles calculados según idioma
  String _projectSubtitle(S t) {
    if (_loadingStats) return t.thisMonth;
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'es') return '+$_projectsThisMonth este mes';
    return '+$_projectsThisMonth this month';
  }

  String _favoritesSubtitle(S t) {
    if (_loadingStats) return t.newItems;
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'es') return '$_newFavoritesThisMonth nuevos';
    return '$_newFavoritesThisMonth new';
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

  @override
  Widget build(BuildContext context) {
    final translations = S.of(context);

    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName  = _userData?['lastName']  ?? _userData?['last_name']  ?? '';
    final initials  = UserService.getInitials(firstName, lastName);
    final photoUrl  = _userData?['photoUrl'] as String?;

    ImageProvider? imageProvider;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('data:image')) {
        final base64Data = photoUrl.split(',').last;
        imageProvider = MemoryImage(base64Decode(base64Data));
      } else {
        imageProvider = NetworkImage(photoUrl);
      }
    }

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

                  // Banner IA
                  HomeAIBanner(
                    translations: translations,
                    onCameraTap: () => _pickImage(ImageSource.camera),
                  ),

                  const SizedBox(height: 16),

                  // 📊 Estadísticas desde Supabase
                  Row(
                    children: [
                      Expanded(
                        child: HomeStatCard(
                          title: translations.projects,
                          value: _loadingStats ? '—' : '$_projectCount',
                          subtitle: _projectSubtitle(translations),
                          subtitleColor: AppColors.passwordStrong,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: HomeStatCard(
                          title: translations.favorites,
                          value: _loadingStats ? '—' : '$_favoriteCount',
                          subtitle: _favoritesSubtitle(translations),
                          subtitleColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🕐 Proyectos recientes desde Supabase
                  HomeSectionTitle(title: translations.recentProjects),
                  const SizedBox(height: 10),

                  if (_loadingStats)
                    const Center(child: CircularProgressIndicator())
                  else if (_recentProjects.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No tienes proyectos aún.',
                        style: TextStyle(color: AppColors.darkTextSecondary),
                      ),
                    )
                  else
                    ..._recentProjects.map((project) {
                      final status = project['status'] ?? 'Draft';
                      return HomeProjectItem(
                        icon: AppEmojis.getRoom(project['room'] ?? ''),
                        name: project['name'] ?? 'Untitled',
                        time: project['created_at'] != null
                            ? _formatDate(project['created_at'])
                            : '',
                        statusColor: _getStatusColor(status),
                      );
                    }),

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