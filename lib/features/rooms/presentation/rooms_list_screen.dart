import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

class RoomsListScreen extends StatelessWidget {
  const RoomsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                'NOS SUITES',
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.5),
                    radius: 1.5,
                    colors: [
                      AppColors.secondaryBlack,
                      AppColors.primaryBlack,
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Liste Streamée depuis Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.white))),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGold),
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Aucune chambre disponible', style: TextStyle(color: Colors.white))),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final id = docs[index].id;
                      
                      // Couleurs alternées pour le placeholder
                      final colors = [
                        AppColors.secondaryBlack,
                        AppColors.primaryBlack,
                        AppColors.secondaryBlack.withOpacity(0.8),
                        AppColors.primaryBlack.withOpacity(0.8),
                      ];

                      // Gestion du prix (rétrocompatibilité)
                      final dynamic rawPrice = data['pricePerNight'] ?? data['price'];
                      final String priceDisplay = rawPrice != null ? '\$$rawPrice' : 'N/A';

                      // Gestion de l'image (rétrocompatibilité)
                      String? displayImage;
                      if (data['imageUrl'] is String) {
                        displayImage = data['imageUrl'];
                      } else if (data['images'] is List && (data['images'] as List).isNotEmpty) {
                        displayImage = (data['images'] as List).first;
                      }

                      // Gestion de la capacité
                      final capacity = data['capacity'] != null ? '${data['capacity']} Pers' : '2-3 Pers';

                      return _RoomCard(
                        roomId: id,
                        name: data['name'] ?? 'Chambre',
                        price: priceDisplay,
                        size: data['size'] ?? 'N/A',
                        view: data['view'] ?? 'Standard',
                        capacity: capacity,
                        imageUrl: displayImage,
                        placeholderColor: colors[index % colors.length],
                        onTap: () => context.push('/rooms/$id'),
                      );
                    },
                    childCount: docs.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String roomId;
  final String name;
  final String price;
  final String size;
  final String view;
  final String capacity;
  final String? imageUrl;
  final Color placeholderColor;
  final VoidCallback onTap;

  const _RoomCard({
    required this.roomId,
    required this.name,
    required this.price,
    required this.size,
    required this.view,
    required this.capacity,
    this.imageUrl,
    required this.placeholderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlack,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl != null && imageUrl!.isNotEmpty)
                      if (imageUrl!.startsWith('http'))
                        CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Icon(
                              Icons.bed_rounded,
                              size: 60,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 40,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        )
                      else
                        Image.asset(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image_rounded,
                              size: 60,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        )
                    else
                      Center(
                        child: Icon(
                          Icons.bed_rounded,
                          size: 60,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: AppColors.primaryGold),
                            const SizedBox(width: 4),
                            const Text(
                              '4.9',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildFeature(Icons.square_foot_rounded, size),
                      const SizedBox(width: 16),
                      _buildFeature(Icons.landscape_rounded, view),
                      const SizedBox(width: 16),
                      _buildFeature(Icons.person_outline_rounded, capacity),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'VOIR LES DÉTAILS',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}
