// lib/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/user_service.dart';
import '../../generated/l10n.dart';
import '../../main.dart';

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final firstName = _userData?['first_name'] ?? '';
    final lastName = _userData?['last_name'] ?? '';
    final initials = UserService.getInitials(firstName, lastName);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(l, firstName, initials),
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
                  _buildSectionTitle(l.exploreStyles),
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

  Widget _buildHeader(S l, String firstName, String initials) {
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
                  child: Text(
                    initials.isNotEmpty ? initials : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
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
                const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
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
          child: _buildStatCard(l.projects, '3', l.thisMonth, AppColors.passwordStrong),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(l.favorites, '12', l.newItems, AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String sub, Color subColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface(context), // ✅ dinámico
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: AppColors.textSecondary(context), fontSize: 11)),
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
            color: AppColors.surface(context), // ✅ dinámico
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.header(context), // ✅ dinámico
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(p['icon'] as String, style: const TextStyle(fontSize: 22)),
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
                      style: TextStyle(color: AppColors.textSecondary(context), fontSize: 11),
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
    final styles = [
      {'icon': '🏠', 'name': l.modern},
      {'icon': '🌿', 'name': l.natural},
      {'icon': '🕯️', 'name': l.minimal},
      {'icon': '🎨', 'name': l.colorful},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: styles.map((s) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context), // ✅ dinámico
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(s['icon'] as String, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                s['name'] as String,
                style: TextStyle(color: AppColors.textPrimary(context), fontSize: 13),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}