import 'package:flutter/material.dart';
import '../emojis/app_emojis.dart';

class StyleCard extends StatelessWidget {
  final String styleKey;
  final bool isSelected;
  final VoidCallback onTap;

  const StyleCard({
    super.key,
    required this.styleKey,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFBE9E7) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppEmojis.getStyle(styleKey),
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              styleKey.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.orange : Colors.black,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.orange, size: 18),
          ],
        ),
      ),
    );
  }
}
