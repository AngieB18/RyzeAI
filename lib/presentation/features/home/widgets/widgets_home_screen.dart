import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../styles/screens/style_selection_sheet.dart';

// ─────────────────────────────────────────
// Header con saludo y avatar del usuario
// ─────────────────────────────────────────
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
                translations.welcomeBack,
                style: TextStyle(
                  color: AppColors.textSecondary(context),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    '${translations.helloUser} $firstName',
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('', style: TextStyle(fontSize: 20)),  
                ],
              ),
            ],
          ),
          loading
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
}

// ─────────────────────────────────────────
// Banner 
// ─────────────────────────────────────────
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
          // Badge "Nuevo"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              translations.newBadge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            translations.decorate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            translations.decorateDesc2,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Botón "Abrir cámara IA"
          GestureDetector(
            onTap: onCameraTap,
            child: Container(
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
                    translations.openCamera,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Tarjeta de estadística (Proyectos / Favoritos)
// ─────────────────────────────────────────
class HomeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  const HomeStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(color: AppColors.textSecondary(context), fontSize: 11),
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
          Text(subtitle, style: TextStyle(color: subtitleColor, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Título de sección genérico
// ─────────────────────────────────────────
class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─────────────────────────────────────────
// Fila de un proyecto reciente
// ─────────────────────────────────────────
class HomeProjectItem extends StatelessWidget {
  final String icon;
  final String name;
  final String time;
  final Color statusColor;

  const HomeProjectItem({
    super.key,
    required this.icon,
    required this.name,
    required this.time,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Ícono del proyecto
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.header(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          // Nombre y tiempo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Indicador de estado
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Título de "Mis estilos" con botón editar
// ─────────────────────────────────────────
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
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: onEditTap,
          child: const Icon(
            Icons.edit_outlined,
            color: AppColors.primary,
            size: 18,
          ),
        ),
      ],
    );
  }
}