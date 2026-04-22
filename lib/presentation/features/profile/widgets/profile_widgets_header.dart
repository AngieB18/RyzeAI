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
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(AppAssets.profileCover),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Large Avatar
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundColor: AppColors.primarySoft,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Text(
                        initials.isNotEmpty ? initials : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            
            // Centered Name
            Text(
              fullName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 3))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
