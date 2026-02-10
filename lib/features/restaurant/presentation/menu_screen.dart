import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/table-booking'),
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.black,
          elevation: 0,
          icon: const Icon(Icons.calendar_today_rounded),
          label: const Text(
            'RÉSERVER UNE TABLE',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    color: AppColors.secondaryBlack, // Teinte chaude sombre (Restaurant)
                    child: const Center(
                      child: Icon(
                        Icons.restaurant,
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
                            'GASTRONOMIE',
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
                          'Le Restaurant',
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
                    .collection('restaurant_menu')
                    .where('category', whereIn: ['breakfast', 'starter', 'main', 'dessert'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Une erreur est survenue', style: TextStyle(color: Colors.white)));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
                  }

                  final docs = snapshot.data!.docs;
                  final breakfasts = docs.where((d) => d['category'] == 'breakfast').toList();
                  final starters = docs.where((d) => d['category'] == 'starter').toList();
                  final mains = docs.where((d) => d['category'] == 'main').toList();
                  final desserts = docs.where((d) => d['category'] == 'dessert').toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (breakfasts.isNotEmpty) ...[
                        _buildSectionTitle('Petit Déjeuner'),
                        const SizedBox(height: 20),
                        ...breakfasts.map((doc) => _MenuItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
                        )),
                        const SizedBox(height: 40),
                      ],

                      if (starters.isNotEmpty) ...[
                        _buildSectionTitle('Entrées'),
                        const SizedBox(height: 20),
                        ...starters.map((doc) => _MenuItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
                        )),
                        const SizedBox(height: 40),
                      ],

                      if (mains.isNotEmpty) ...[
                        _buildSectionTitle('Plats Signature'),
                        const SizedBox(height: 20),
                        ...mains.map((doc) => _MenuItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
                        )),
                        const SizedBox(height: 40),
                      ],

                      if (desserts.isNotEmpty) ...[
                        _buildSectionTitle('Desserts'),
                        const SizedBox(height: 20),
                        ...desserts.map((doc) => _MenuItem(
                          name: doc['name'],
                          description: doc['description'],
                          price: '\$${doc['price']}',
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

class _MenuItem extends StatelessWidget {
  final String name;
  final String description;
  final String price;

  const _MenuItem({
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
