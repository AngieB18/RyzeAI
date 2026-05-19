import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';
import '../../styles/screens/style_selection_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Header con saludo y avatar
// ─────────────────────────────────────────────────────────────────────────────
class HomeHeader extends StatelessWidget {
  final S translations;
  final String firstName;
  final String initials;
  final ImageProvider? imageProvider;
  final bool loading;

  const HomeHeader({
    super.key,
    required this.translations,
    required this.firstName,
    required this.initials,
    required this.imageProvider,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translations.welcomeBack,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${translations.helloUser} $firstName',
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          loading
              ? CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.inputBorder(context),
                )
              : CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          initials.isNotEmpty ? initials : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )
                      : null,
                ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner IA
// ─────────────────────────────────────────────────────────────────────────────
class HomeAIBanner extends StatelessWidget {
  final S translations;
  final VoidCallback onCameraTap;

  const HomeAIBanner({
    super.key,
    required this.translations,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFBF6D3A), Color(0xFF7A3B10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBF6D3A).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translations.decorate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  translations.decorateDesc2,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onCameraTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.camera_alt_rounded,
                            color: Color(0xFFBF6D3A), size: 15),
                        const SizedBox(width: 6),
                        Text(
                          translations.openCamera,
                          style: const TextStyle(
                            color: Color(0xFFBF6D3A),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Decoración visual derecha
          Column(
            children: [
              Text('🛋️', style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 8),
              Text('🎨', style: const TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tarjeta de estadística — ahora con emoji
// ─────────────────────────────────────────────────────────────────────────────
class HomeStatCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  const HomeStatCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: subtitleColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Título de sección
// ─────────────────────────────────────────────────────────────────────────────
class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Proyecto reciente — con imagen, badges público/favorito
// ─────────────────────────────────────────────────────────────────────────────
class HomeProjectItem extends StatelessWidget {
  final String icon;
  final String name;
  final String time;
  final String? imageUrl;
  final bool isPublic;
  final bool isFavorite;

  const HomeProjectItem({
    super.key,
    required this.icon,
    required this.name,
    required this.time,
    this.imageUrl,
    required this.isPublic,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ── Imagen o ícono ───────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _iconPlaceholder(context),
                  )
                : _iconPlaceholder(context),
          ),

          const SizedBox(width: 14),

          // ── Info ─────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Badges
                  Row(
                    children: [
                      if (isFavorite)
                        _badge(
                          AppEmojis.favoriteActive,
                          AppColors.passwordWeak.withOpacity(0.15),
                        ),
                      if (isFavorite) const SizedBox(width: 6),
                      _badge(
                        isPublic ? AppEmojis.publicProject : AppEmojis.privateProject,
                        AppColors.surface(context),
                        border: true,
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Tiempo ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Text(
              time,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconPlaceholder(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      color: AppColors.header(context),
      child: Center(
        child: Text(icon, style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  Widget _badge(String emoji, Color bg,
      {bool border = false, BuildContext? context}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: border && context != null
            ? Border.all(color: AppColors.inputBorder(context), width: 1)
            : null,
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 12)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Estado vacío — sin proyectos
// ─────────────────────────────────────────────────────────────────────────────
class HomeEmptyProjects extends StatelessWidget {
  final S strings;

  const HomeEmptyProjects({super.key, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.inputBorder(context),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(AppEmojis.defaultRoom, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          Text(
            strings.home_empty_projects,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Título de "Mis estilos" con botón editar (se mantiene por si se reactiva)
// ─────────────────────────────────────────────────────────────────────────────
class HomeStylesSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onEditTap;

  const HomeStylesSectionTitle({
    super.key,
    required this.title,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
        ),
      ],
    );
  }
}
