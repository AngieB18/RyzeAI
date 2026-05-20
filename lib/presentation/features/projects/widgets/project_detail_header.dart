import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../presentation/widgets/emojis/app_emojis.dart';

class ProjectDetailHeader extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final bool hasOriginal;
  final bool hasGenerated;
  final bool showingOriginal;
  final VoidCallback onShowOriginal;
  final VoidCallback onShowGenerated;
  final String originalLabel;
  final String generatedLabel;

  const ProjectDetailHeader({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.hasOriginal,
    required this.hasGenerated,
    required this.showingOriginal,
    required this.onShowOriginal,
    required this.onShowGenerated,
    required this.originalLabel,
    required this.generatedLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (imageUrl != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(
                      backgroundColor: Colors.black,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    body: Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            );
                          },
                          errorBuilder: (context, error, stack) => const Icon(
                            Icons.broken_image_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Container(
              key: ValueKey(imageUrl),
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkHeader.withValues(alpha: 0.15),
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background(context).withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
        ),
        if (imageUrl != null)
          Positioned(
            bottom: 50,
            right: 20,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  AppEmojis.zoomHint,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 60,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (hasOriginal && hasGenerated)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProjectDetailToggleChip(
                    label: originalLabel,
                    active: showingOriginal,
                    onTap: onShowOriginal,
                  ),
                  ProjectDetailToggleChip(
                    label: generatedLabel,
                    active: !showingOriginal,
                    onTap: onShowGenerated,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class ProjectDetailToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const ProjectDetailToggleChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
