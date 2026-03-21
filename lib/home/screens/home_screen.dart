// lib/home/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/user_service.dart';
import '../../generated/l10n.dart';
import '../../main.dart';
import 'style_selection_sheet.dart';
import 'style_inspiration_screen.dart';

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

      final stylesSelected = data?['stylesSelected'] ?? false;
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

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['firstName'] ?? _userData?['first_name'] ?? '';
    final lastName = _userData?['lastName'] ?? _userData?['last_name'] ?? '';
    final initials = UserService.getInitials(firstName, lastName);
    final photoUrl = _userData?['photoUrl'] as String?;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l, firstName, initials, photoUrl),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAIBanner(context, l),
                  const SizedBox(height: 16),
                  _buildStatsRow(l),
                  const SizedBox(height: 20),
                  _buildSectionTitle(l.recentProjects),
                  const SizedBox(height: 10),
                  _buildRecentProjects(l),
                  const SizedBox(height: 20),
                  _buildStylesSectionTitle(l),
                  const SizedBox(height: 10),
                  _buildStylesGrid(l),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    S l,
    String firstName,
    String initials,
    String? photoUrl,
  ) {
    ImageProvider? imageProvider;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('data:image')) {
        final base64Data = photoUrl.split(',').last;
        imageProvider = MemoryImage(base64Decode(base64Data));
      } else {
        imageProvider = NetworkImage(photoUrl);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 80, 20),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.welcomeBack,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              _loading
                  ? SizedBox(
                      width: 160,
                      height: 26,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.inputBorder(context),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Text(
                          '${l.helloUser} $firstName',
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('👋', style: TextStyle(fontSize: 20)),
                      ],
                    ),
            ],
          ),
          _loading
              ? CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.inputBorder(context),
                )
              : CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          initials.isNotEmpty ? initials : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
        ],
      ),
    );
  }

  Widget _buildAIBanner(BuildContext context, S l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFBF6D3A), Color(0xFF8B4513)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              l.newBadge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.decorate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.decorateDesc2,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  l.openCamera,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(S l) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l.projects,
            '3',
            l.thisMonth,
            AppColors.passwordStrong,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l.favorites,
            '12',
            l.newItems,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String sub,
    Color subColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(color: subColor, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildStylesSectionTitle(S l) {
    final userStyles = List<String>.from(_userData?['styles'] ?? []);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          userStyles.isEmpty ? l.exploreStyles : l.myStyles,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 15,
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
                initialSelected: userStyles,
                onSaved: _loadUser,
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
    );
  }

  Widget _buildRecentProjects(S l) {
    final projects = [
      {
        'icon': '🛋️',
        'name': l.livingRoom,
        'time': '${l.modifiedAgo} ${l.hoursAgo}',
        'status': AppColors.passwordStrong,
      },
      {
        'icon': '🛏️',
        'name': l.bedroom,
        'time': '${l.modifiedAgo} ${l.yesterday}',
        'status': AppColors.passwordMedium,
      },
    ];

    return Column(
      children: projects.map((p) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.header(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    p['icon'] as String,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name'] as String,
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      p['time'] as String,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: p['status'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStylesGrid(S l) {
    final allStyles = {
      'modern': {
        'name': l.styleModern,
        'url':
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&q=80',
      },
      'natural': {
        'name': l.styleNatural,
        'url':
            'https://images.unsplash.com/photo-1501183638710-841dd1904471?w=400&q=80',
      },
      'minimal': {
        'name': l.styleMinimal,
        'url':
            'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=400&q=80',
      },
      'colorful': {
        'name': l.styleColorful,
        'url':
            'https://images.unsplash.com/photo-1618220179428-22790b461013?w=400&q=80',
      },
      'rustic': {
        'name': l.styleRustic,
        'url':
            'https://images.unsplash.com/photo-1449247709967-d4461a6a6103?w=400&q=80',
      },
      'scandinavian': {
        'name': l.styleScandinavian,
        'url':
            'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=400&q=80',
      },
    };

    final userStyles = List<String>.from(_userData?['styles'] ?? []);
    final stylesToShow = userStyles.isEmpty
        ? allStyles.entries.toList()
        : allStyles.entries.where((e) => userStyles.contains(e.key)).toList();

    if (stylesToShow.isEmpty) {
      return Center(
        child: Text(
          l.noStylesSelected,
          style: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: 13,
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stylesToShow.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final entry = stylesToShow[i];
          final name = entry.value['name']!;
          final url = entry.value['url']!;

          return GestureDetector(
            // ← navega a StyleInspirationScreen
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StyleInspirationScreen(
                  styleKey: entry.key,
                  styleName: name,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.surface(context),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface(context),
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
