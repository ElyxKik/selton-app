import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

class CocktailsScreen extends StatelessWidget {
  const CocktailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder Image
                  Container(
                    color: AppColors.secondaryBlack, // Teinte bleutée sombre (Bar Jazz)
                    child: const Center(
                      child: Icon(
                        Icons.local_bar,
                        size: 80,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          AppColors.primaryBlack,
                        ],
                      ),
                    ),
                  ),
                  // Title
                  Positioned(
                    bottom: 20,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'LOUNGE BAR',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Cocktails & Vins',
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bar_menu')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Une erreur est survenue', style: TextStyle(color: Colors.white)));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
                  }

                  final docs = snapshot.data!.docs;
                  final signatures = docs.where((d) => d['category'] == 'signature').toList();
                  final classics = docs.where((d) => d['category'] == 'classic').toList();
                  final softs = docs.where((d) => d['category'] == 'soft').toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (signatures.isNotEmpty) ...[
                        _buildSectionTitle('Signatures'),
                        const SizedBox(height: 20),
                        ...signatures.map((doc) => _CocktailItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
                          imageUrl: (doc.data() as Map<String, dynamic>).containsKey('imageUrl') ? doc['imageUrl'] : null,
                        )),
                        const SizedBox(height: 40),
                      ],

                      if (classics.isNotEmpty) ...[
                        _buildSectionTitle('Classiques'),
                        const SizedBox(height: 20),
                        ...classics.map((doc) => _CocktailItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
                          imageUrl: (doc.data() as Map<String, dynamic>).containsKey('imageUrl') ? doc['imageUrl'] : null,
                        )),
                        const SizedBox(height: 40),
                      ],

                      if (softs.isNotEmpty) ...[
                        _buildSectionTitle('Sans Alcool'),
                        const SizedBox(height: 20),
                        ...softs.map((doc) => _CocktailItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
                          imageUrl: (doc.data() as Map<String, dynamic>).containsKey('imageUrl') ? doc['imageUrl'] : null,
                        )),
                      ],
                      
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Playfair',
            fontSize: 24,
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 2,
          color: AppColors.primaryGold.withOpacity(0.5),
        ),
      ],
    );
  }
}

class _CocktailItem extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String? imageUrl;

  const _CocktailItem({
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: Icon(Icons.local_bar, color: Colors.white24, size: 24),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error_outline, color: Colors.white24, size: 24),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.local_bar, color: AppColors.primaryGold, size: 24),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
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
    );
  }
}
