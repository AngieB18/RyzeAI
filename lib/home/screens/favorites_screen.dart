// lib/home/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../generated/l10n.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    final items = [
      {
        'icon': '🛋️',
        'name': 'Scandinavian Sofa',
        'store': 'IKEA',
        'price': '\$899',
      },
      {
        'icon': '💡',
        'name': 'Arc Floor Lamp',
        'store': 'Wayfair',
        'price': '\$230',
      },
      {'icon': '🪑', 'name': 'Accent Chair', 'store': 'CB2', 'price': '\$540'},
      {
        'icon': '🖼️',
        'name': 'Abstract Art Print',
        'store': 'Society6',
        'price': '\$75',
      },
      {
        'icon': '🛏️',
        'name': 'Linen Bed Frame',
        'store': 'West Elm',
        'price': '\$1,200',
      },
      {
        'icon': '🪴',
        'name': 'Monstera Plant',
        'store': 'The Sill',
        'price': '\$65',
      },
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(l),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _buildFavoriteCard(items[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(S l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 70, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2A1F1A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Text(
        l.favorites,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF3A2218),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    item['icon']!,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2C2E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.primary,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name']!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item['store']!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['price']!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
