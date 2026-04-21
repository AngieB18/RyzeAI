// lib/home/screens/my_designs_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ryzeai/core/constants/app_colors.dart';
import 'package:ryzeai/generated/l10n.dart';


class MyDesignsScreen extends StatefulWidget {
  const MyDesignsScreen({super.key});

  @override
  State<MyDesignsScreen> createState() => _MyDesignsScreenState();
}

class _MyDesignsScreenState extends State<MyDesignsScreen> {
  late Future<List<Map<String, dynamic>>> _designsFuture;

  @override
  void initState() {
    super.initState();
    _designsFuture = _loadDesigns();
  }

  Future<List<Map<String, dynamic>>> _loadDesigns() async {
    final supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser?.id;

    if (uid == null) return [];

    final response = await supabase
        .from('my_designs')
        .select()
        .eq('user_id', uid)
        .order('createdAt', ascending: false);

    return List<Map<String, dynamic>>.from(response ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.header(context),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: AppColors.textPrimary(context),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l.myDesigns,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),

            // Diseños
            Expanded(
              child: uid == null
                  ? Center(
                      child: Text(
                        l.noDesignsYet,
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    )
                  : FutureBuilder<List<Map<String, dynamic>>>(
                      future: _designsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }

                        final docs = snapshot.data ?? [];

                        if (docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.primary,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l.noDesignsYet,
                                  style: TextStyle(
                                    color: AppColors.textSecondary(context),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: docs.length,
                          itemBuilder: (_, i) {
                            final data = docs[i];
                            return _buildDesignCard(
                              context,
                              data,
                              data['id'] as String,
                              uid,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesignCard(
    BuildContext context,
    Map<String, dynamic> data,
    String docId,
    String uid,
  ) {
    final imageUrl = data['imageUrl'] as String? ?? '';
    final title = data['title'] as String? ?? '';
    final style = data['style'] as String? ?? '';
    final room = data['room'] as String? ?? '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.header(context),
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  // Delete button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () async {
                        await Supabase.instance.client
                            .from('my_designs')
                            .delete()
                            .eq('id', docId);
                        if (mounted) {
                          setState(() {
                            _designsFuture = _loadDesigns();
                          });
                        }
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        style,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      room.replaceAll('_', ' '),
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
