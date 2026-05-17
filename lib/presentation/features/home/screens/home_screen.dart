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
import 'package:ryzeai/presentation/features/camera/screens/style_inspiration_screen.dart';

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
  int _publicCount = 0;
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
            builder: (_) => StyleInspirationScreen(image: imageFile),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(AppEmojis.error, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(S.of(context).home_error_image_pick(e.toString())),
              ),
            ],
          ),
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
        WidgetsBinding.instance.addPostFrameCallback((_) => _showStyleSheet());
      }
    }
  }

  Future<void> _loadStats() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final projects = await _supabase
          .from('projects')
          .select(
              'id, user_id, name_projects, id_type_room, created_at, updated_at, is_favorite, public_state, generated_image_url, original_image_url')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final allProjects = List<Map<String, dynamic>>.from(projects);
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      int projectsThisMonth = 0;
      int newFavoritesThisMonth = 0;

      for (final p in allProjects) {
        final createdAt = _parseDate(p['created_at']);
        final updatedAt = _parseDate(p['updated_at']);
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
      final publicOnes = allProjects.where((p) => p['public_state'] == true).toList();

      if (mounted) {
        setState(() {
          _projectCount = allProjects.length;
          _favoriteCount = favorites.length;
          _publicCount = publicOnes.length;
          _recentProjects = allProjects.take(3).toList();
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

  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toLocal();
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value)?.toLocal();
    }
    return null;
  }

  String _formatDate(String isoDate) {
    final strings = S.of(context);
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) return strings.home_time_minutes(diff.inMinutes);
      if (diff.inHours < 24) return strings.home_time_hours(diff.inHours);
      if (diff.inDays == 1) return strings.home_time_yesterday;
      return strings.home_time_days(diff.inDays);
    } catch (_) {
      return isoDate;
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

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName = _userData?['lastName'] ?? _userData?['last_name'] ?? '';
    final initials = UserService.getInitials(firstName, lastName);
    final photoUrl = _userData?['photoUrl'] as String?;

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

            // ── Header ──────────────────────────────────────────────────
            HomeHeader(
              translations: strings,
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

                  // ── Banner IA ─────────────────────────────────────────
                  HomeAIBanner(
                    translations: strings,
                    onCameraTap: () => _pickImage(ImageSource.camera),
                  ),

                  const SizedBox(height: 20),

                  // ── Estadísticas ──────────────────────────────────────
                  HomeSectionTitle(title: strings.home_section_stats),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: HomeStatCard(
                          emoji: AppEmojis.defaultRoom,
                          title: strings.projects,
                          value: _loadingStats ? '—' : '$_projectCount',
                          subtitle: strings.home_stat_this_month(_projectsThisMonth),
                          subtitleColor: AppColors.passwordStrong,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: HomeStatCard(
                          emoji: AppEmojis.favoriteActive,
                          title: strings.favorites,
                          value: _loadingStats ? '—' : '$_favoriteCount',
                          subtitle: strings.home_stat_new(_newFavoritesThisMonth),
                          subtitleColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: HomeStatCard(
                          emoji: AppEmojis.publicProject,
                          title: strings.home_stat_public_label,
                          value: _loadingStats ? '—' : '$_publicCount',
                          subtitle: strings.home_stat_published,
                          subtitleColor: AppColors.passwordMedium,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Proyectos recientes ───────────────────────────────
                  HomeSectionTitle(title: strings.recentProjects),
                  const SizedBox(height: 12),

                  if (_loadingStats)
                    const Center(child: CircularProgressIndicator())
                  else if (_recentProjects.isEmpty)
                    HomeEmptyProjects(strings: strings)
                  else
                    ..._recentProjects.map((project) {
                      final imageUrl =
                          (project['generated_image_url'] ?? project['original_image_url'])
                              ?.toString();
                      return HomeProjectItem(
                        icon: AppEmojis.defaultRoom,
                        name: project['name_projects'] ?? strings.projects_untitled,
                        time: project['created_at'] != null
                            ? _formatDate(project['created_at'])
                            : '',
                        imageUrl: imageUrl,
                        isPublic: project['public_state'] == true,
                        isFavorite: project['is_favorite'] == true,
                      );
                    }),

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
