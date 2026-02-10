import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/auth_provider.dart';

/// Écran d'accueil principal
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBlack, // Fond noir pour continuité
      body: CustomScrollView(
        slivers: [
          // App Bar "Ethereal Gold"
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryBlack,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppColors.primaryGold,
                    AppColors.primaryGoldLight,
                    AppColors.primaryGold,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'SELTON',
                  style: TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/home_header_bg.jpg',
                    fit: BoxFit.cover,
                  ),
                  // Overlay sombre pour la lisibilité
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryBlack.withOpacity(0.3),
                          AppColors.primaryBlack,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Message
                  userProfileAsync.when(
                    data: (data) {
                      // On récupère fullName en priorité
                      final fullName = data?['fullName'] as String? ?? '';
                      // On essaie d'extraire le prénom, sinon on prend tout
                      final firstName = fullName.isNotEmpty 
                          ? fullName.split(' ').first 
                          : (data?['firstName'] as String? ?? '');
                          
                      return Text(
                        firstName.isNotEmpty ? 'Bonjour, $firstName' : 'Bonjour',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Playfair',
                          color: Colors.white,
                          height: 1.1,
                        ),
                      );
                    },
                    loading: () => const Text(
                      'Bonjour',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Playfair',
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    error: (_, __) => const Text(
                      'Bonjour',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Playfair',
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('experiences')
                        .where('isFeatured', isEqualTo: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlack,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          padding: const EdgeInsets.all(24),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Impossible de charger l\'expérience mise en avant\n${snapshot.error}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlack,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Chargement de l\'expérience...',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBlack,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.event, color: AppColors.primaryGold),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Aucune expérience mise en avant pour le moment',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                      final title = (data['title'] as String?) ?? 'Expérience';
                      final description = (data['description'] as String?) ?? '';
                      final dateRaw = data['date'];
                      final String? date = dateRaw is Timestamp
                          ? dateRaw.toDate().toIso8601String()
                          : dateRaw as String?;
                      final imageUrl = data['imageUrl'] as String?;

                      String? formattedDate;
                      if (date != null && date.isNotEmpty) {
                        try {
                          final dt = DateTime.parse(date);
                          formattedDate = '${dt.day}/${dt.month} à ${dt.hour}h${dt.minute.toString().padLeft(2, '0')}';
                        } catch (_) {}
                      }

                      return InkWell(
                        onTap: () => context.push('/experience-detail', extra: {
                          'title': title,
                          'date': date,
                          'imageUrl': imageUrl,
                          'description': description,
                        }),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: imageUrl == null ? AppColors.secondaryBlack : null,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlack.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryBlack.withOpacity(0.2),
                                  AppColors.primaryBlack.withOpacity(0.9),
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'EXPÉRIENCE',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withOpacity(0.9),
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: 'Playfair',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (description.isNotEmpty || formattedDate != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          formattedDate ?? description,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13,
                                            color: Colors.white.withOpacity(0.85),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.15),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: AppColors.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // 2. Featured Room (Mise en avant)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('À la Une', style: _sectionTitleStyle),
                      TextButton(
                        onPressed: () => context.push('/rooms'),
                        child: Text('Tout voir', style: _linkStyle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rooms')
                        .where('isFeatured', isEqualTo: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      
                      final doc = snapshot.data!.docs.first;
                      final data = doc.data() as Map<String, dynamic>;
                      final id = doc.id;
                      
                      return _FeaturedRoomCard(
                        name: data['name'] ?? 'Chambre',
                        price: '\$${data['pricePerNight'] ?? data['price'] ?? '0'}',
                        size: data['size'] ?? 'N/A',
                        view: data['view'] ?? 'Vue Standard',
                        onTap: () => context.push('/rooms/$id'),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // 2. Services Grid (Redesigned)
                  Text('Nos Services', style: _sectionTitleStyle),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _ServiceCard(
                        icon: Icons.bed_rounded,
                        title: 'Suites',
                        subtitle: 'Nos Chambres',
                        onTap: () => context.push('/rooms'),
                      ),
                      _ServiceCard(
                        icon: Icons.restaurant_rounded,
                        title: 'Gastronomie',
                        subtitle: 'Le Restaurant',
                        onTap: () => context.push('/menu'),
                      ),
                      _ServiceCard(
                        icon: Icons.local_bar_rounded,
                        title: 'Bar',
                        subtitle: 'Cocktails & Vins',
                        onTap: () => context.push('/bar'),
                      ),
                      _ServiceCard(
                        icon: Icons.meeting_room_rounded,
                        title: 'Salles',
                        subtitle: 'Événements',
                        onTap: () => context.push('/halls'),
                      ),
                      _ServiceCard(
                        icon: Icons.airport_shuttle_rounded,
                        title: 'Navette',
                        subtitle: 'Aéroport',
                        onTap: () => context.push('/shuttle'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 3. Expériences Exclusives
                  Text('Expériences & Événements', style: _sectionTitleStyle),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 280, // Increased height for better image display
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('experiences')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Erreur de chargement', style: TextStyle(color: Colors.white)));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
                        }

                        final docs = snapshot.data!.docs;

                        if (docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'Aucun événement à venir',
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: _ExperienceCard(
                                title: data['title'] ?? 'Expérience',
                                date: (() {
                                  final dateRaw = data['date'];
                                  if (dateRaw is Timestamp) {
                                    return dateRaw.toDate().toIso8601String();
                                  }
                                  return dateRaw as String?;
                                })(),
                                imageUrl: data['imageUrl'],
                                onTap: () => context.push('/experience-detail', extra: {
                                  'title': data['title'],
                                  'date': (() {
                                    final dateRaw = data['date'];
                                    if (dateRaw is Timestamp) {
                                      return dateRaw.toDate().toIso8601String();
                                    }
                                    return dateRaw as String?;
                                  })(),
                                  'imageUrl': data['imageUrl'],
                                  'description': data['description'] ?? '',
                                }),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Styles helpers
  TextStyle get _sectionTitleStyle => const TextStyle(
    fontFamily: 'Playfair',
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryGold,
  );

  TextStyle get _linkStyle => TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryGold.withOpacity(0.7),
  );
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondaryBlack,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primaryGold,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Playfair',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                color: Colors.white.withOpacity(0.5),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedRoomCard extends StatelessWidget {
  final String name;
  final String price;
  final String size;
  final String view;
  final VoidCallback onTap;

  const _FeaturedRoomCard({
    required this.name,
    required this.price,
    required this.size,
    required this.view,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondaryBlack.withOpacity(0.8),
              AppColors.secondaryBlack,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'COUP DE CŒUR',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$view • $size',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontFamily: 'Playfair',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4, left: 4),
                            child: Text(
                              '/ nuit',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: AppColors.primaryGold.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primaryGold,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final String title;
  final String? date;
  final String? imageUrl;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.title,
    this.date,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String? formattedDate;
    if (date != null && date!.isNotEmpty) {
      try {
        final dt = DateTime.parse(date!);
        formattedDate = '${dt.day}/${dt.month} à ${dt.hour}h${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 220, // Increased width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
          color: imageUrl == null ? AppColors.secondaryBlack : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.primaryBlack.withOpacity(0.2),
                AppColors.primaryBlack.withOpacity(0.9),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (imageUrl == null) ...[
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.event, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (formattedDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: AppColors.primaryGold.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: AppColors.primaryGold.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
