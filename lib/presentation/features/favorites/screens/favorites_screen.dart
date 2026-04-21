// lib/home/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../generated/l10n.dart';
import 'package:ryzeai/presentation/widgets/index.dart';

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
    return SimpleHeader(title: l.favorites);
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, String> item) {
    return FavoriteCard(
      icon: item['icon']!,
      name: item['name']!,
      store: item['store']!,
      price: item['price']!,
    );
  }
}