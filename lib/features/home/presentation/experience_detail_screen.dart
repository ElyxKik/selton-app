import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ExperienceDetailScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? themeColor;
  final String description;
  final String? price;
  final String? duration;
  final String? imageUrl;
  final String? date;

  const ExperienceDetailScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.themeColor,
    required this.description,
    this.price,
    this.duration,
    this.imageUrl,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    String? formattedDate;
    if (date != null && date!.isNotEmpty) {
      try {
        final dt = DateTime.parse(date!);
        formattedDate = '${dt.day}/${dt.month}/${dt.year} à ${dt.hour}h${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
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
                  // Image or Placeholder
                  if (imageUrl != null && imageUrl!.isNotEmpty)
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: themeColor ?? AppColors.secondaryBlack,
                      child: Center(
                        child: Icon(
                          Icons.star,
                          size: 80,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  // Gradient Overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryBlack.withOpacity(0.3),
                          Colors.transparent,
                          AppColors.primaryBlack,
                        ],
                      ),
                    ),
                  ),
                  // Content overlay
                  Positioned(
                    bottom: 20,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subtitle?.toUpperCase() ?? 'EXPÉRIENCE',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.1,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Row
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryBlack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (formattedDate != null)
                           _buildInfoItem(Icons.calendar_today, formattedDate, 'Date'),
                        if (duration != null)
                          _buildInfoItem(Icons.access_time_rounded, duration!, 'Durée'),
                        if (price != null)
                          _buildInfoItem(Icons.euro_rounded, price!, 'Par personne'),
                        if (formattedDate == null && duration == null && price == null)
                           _buildInfoItem(Icons.info_outline, 'Détails', 'Voir ci-dessous'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'À propos',
                    style: const TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      color: AppColors.primaryGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Ce qui est inclus',
                    style: const TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 20,
                      color: AppColors.primaryGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem('Service VIP dédié'),
                  _buildFeatureItem('Accès prioritaire'),
                  _buildFeatureItem('Boisson de bienvenue'),
                  
                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Demande de réservation envoyée', style: TextStyle(color: Colors.white)),
                backgroundColor: AppColors.primaryGold,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGold,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: AppColors.primaryGold.withOpacity(0.4),
          ),
          child: const Text(
            'RÉSERVER CETTE EXPÉRIENCE',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 12, color: AppColors.primaryGold),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
