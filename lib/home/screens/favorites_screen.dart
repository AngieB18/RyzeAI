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
      {'icon': '🛋️', 'name': 'Scandinavian Sofa', 'store': 'IKEA', 'price': '\$899'},
      {'icon': '💡', 'name': 'Arc Floor Lamp', 'store': 'Wayfair', 'price': '\$230'},
      {'icon': '🪑', 'name': 'Accent Chair', 'store': 'CB2', 'price': '\$540'},
      {'icon': '🖼️', 'name': 'Abstract Art Print', 'store': 'Society6', 'price': '\$75'},
      {'icon': '🛏️', 'name': 'Linen Bed Frame', 'store': 'West Elm', 'price': '\$1,200'},
      {'icon': '🪴', 'name': 'Monstera Plant', 'store': 'The Sill', 'price': '\$65'},
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l),
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
              itemBuilder: (ctx, i) => _buildFavoriteCard(ctx, items[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, S l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 70, 20),
      decoration: BoxDecoration(
        color: AppColors.header(context),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Text(
        l.favorites,
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.darkHeader.withOpacity(0.8),
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
                    decoration: BoxDecoration(
                      color: AppColors.surface(context),
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
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item['store']!,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
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