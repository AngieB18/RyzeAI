import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../generated/l10n.dart';

class ProfileWidgetsHeader extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final String fullName;
  final String initials;

  const ProfileWidgetsHeader({
    super.key,
    required this.userData,
    required this.fullName,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = userData?['photoUrl'] as String?;
    ImageProvider? imageProvider;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      if (photoUrl.startsWith('data:image')) {
        final base64Data = photoUrl.split(',').last;
        imageProvider = MemoryImage(base64Decode(base64Data));
      } else if (!photoUrl.endsWith('.svg')) {
        imageProvider = NetworkImage(photoUrl);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface(context),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.primary,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Text(
                      initials.isNotEmpty ? initials : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            fullName,
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userData?['email'] ?? '',
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
