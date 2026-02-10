import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/luxury_sliver_appbar.dart';

/// 🏠 HOME SCREEN AVEC LUXURY APPBAR
/// Exemple d'intégration de la LuxurySliverAppBar dans le HomeScreen
class HomeScreenWithLuxuryAppBar extends StatefulWidget {
  const HomeScreenWithLuxuryAppBar({super.key});

  @override
  State<HomeScreenWithLuxuryAppBar> createState() => _HomeScreenWithLuxuryAppBarState();
}

class _HomeScreenWithLuxuryAppBarState extends State<HomeScreenWithLuxuryAppBar> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _guests = 1;

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.pureWhite,
              surface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _checkInDate) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
          _checkOutDate = null;
        }
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? (_checkInDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1))),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.pureWhite,
              surface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 🏆 LUXURY APPBAR
          LuxurySliverAppBar(
            showBackButton: false,
            onMenuPressed: () {
              // Ouvrir le drawer ou menu
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu ouvert')),
              );
            },
            onProfilePressed: () {
              // Naviguer vers le profil
              context.push('/profile');
            },
          ),

          // Contenu principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message de bienvenue
                  Text('Bienvenue', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Découvrez l\'excellence du luxe',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Widget de réservation
                  _buildBookingCard(),
                  
                  const SizedBox(height: 32),
                  
                  // Services
                  Text('Services', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _ServiceCard(
                        icon: Icons.hotel_rounded,
                        title: 'Chambres',
                        subtitle: 'Suites de luxe',
                        onTap: () => context.push('/rooms'),
                      ),
                      _ServiceCard(
                        icon: Icons.restaurant_rounded,
                        title: 'Restaurant',
                        subtitle: 'Cuisine gastronomique',
                        onTap: () => context.push('/menu'),
                      ),
                      _ServiceCard(
                        icon: Icons.local_bar_rounded,
                        title: 'Bar',
                        subtitle: 'Cocktails signature',
                        onTap: () => context.push('/cocktails'),
                      ),
                      _ServiceCard(
                        icon: Icons.spa_rounded,
                        title: 'Spa',
                        subtitle: 'Détente & bien-être',
                        onTap: () => context.push('/services'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: AppColors.pureWhite, size: 28),
                const SizedBox(width: 12),
                Text('Réserver votre séjour', style: AppTextStyles.h3.copyWith(color: AppColors.pureWhite)),
              ],
            ),
            const SizedBox(height: 24),
            _buildDateSelector(label: 'Arrivée', date: _checkInDate, onTap: () => _selectCheckInDate(context), icon: Icons.login_rounded),
            const SizedBox(height: 16),
            _buildDateSelector(label: 'Départ', date: _checkOutDate, onTap: () => _selectCheckOutDate(context), icon: Icons.logout_rounded),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.pureWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.pureWhite.withOpacity(0.3), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.people_rounded, color: AppColors.pureWhite),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Personnes', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.pureWhite))),
                  IconButton(
                    onPressed: () { if (_guests > 1) setState(() => _guests--); },
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.pureWhite),
                  ),
                  Text('$_guests', style: AppTextStyles.h4.copyWith(color: AppColors.pureWhite)),
                  IconButton(
                    onPressed: () { if (_guests < 10) setState(() => _guests++); },
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.pureWhite),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkInDate != null && _checkOutDate != null ? () {
                  final nights = _checkOutDate!.difference(_checkInDate!).inDays;
                  context.push('/rooms');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Recherche: $_guests personne(s), $nights nuit(s)', style: const TextStyle(color: AppColors.pureWhite)),
                      backgroundColor: AppColors.primaryBlack,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pureWhite,
                  foregroundColor: AppColors.primaryGold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_rounded, size: 24),
                    const SizedBox(width: 8),
                    Text('Rechercher', style: AppTextStyles.h4.copyWith(color: AppColors.primaryGold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({required String label, required DateTime? date, required VoidCallback onTap, required IconData icon}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.pureWhite.withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.pureWhite),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.pureWhite.withOpacity(0.8))),
                  const SizedBox(height: 4),
                  Text(
                    date != null ? '${date.day}/${date.month}/${date.year}' : 'Sélectionner une date',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.pureWhite, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today_rounded, color: AppColors.pureWhite.withOpacity(0.6), size: 20),
          ],
        ),
      ),
    );
  }
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.mediumGray),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 30, color: AppColors.pureWhite),
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.darkGray), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
