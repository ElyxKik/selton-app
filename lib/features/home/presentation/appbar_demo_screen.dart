import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/luxury_sliver_appbar.dart';
import '../../../core/widgets/gradient_sliver_appbar.dart';
import '../../../core/widgets/minimal_sliver_appbar.dart';

/// 🎨 ÉCRAN DE DÉMONSTRATION DES 3 VARIANTES D'APPBAR
/// 
/// Utilisez ce fichier pour tester et comparer les 3 styles d'AppBar premium.
/// Changez simplement le widget dans le CustomScrollView pour voir chaque variante.
class AppBarDemoScreen extends StatefulWidget {
  const AppBarDemoScreen({super.key});

  @override
  State<AppBarDemoScreen> createState() => _AppBarDemoScreenState();
}

class _AppBarDemoScreenState extends State<AppBarDemoScreen> {
  int _selectedVariant = 0; // 0: Luxury, 1: Gradient, 2: Minimal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Choisir la variante à afficher
          _buildSelectedAppBar(),
          
          // Contenu de démonstration
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Sélecteur de variante
                _buildVariantSelector(),
                
                const SizedBox(height: 32),
                
                // Contenu de test pour le scroll
                _buildDemoContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAppBar() {
    switch (_selectedVariant) {
      case 0:
        return const LuxurySliverAppBar(
          showBackButton: false,
        );
      case 1:
        return const GradientSliverAppBar(
          showBackButton: false,
        );
      case 2:
        return const MinimalSliverAppBar(
          showBackButton: false,
        );
      default:
        return const LuxurySliverAppBar();
    }
  }

  Widget _buildVariantSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.secondaryBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Choisir une variante',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildVariantButton(
                  title: 'Luxe',
                  subtitle: 'Noir + Or',
                  index: 0,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlack,
                      AppColors.primaryBlack.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildVariantButton(
                  title: 'Dégradé',
                  subtitle: 'Premium',
                  index: 1,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryBlack,
                      AppColors.secondaryBlack,
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildVariantButton(
                  title: 'Minimal',
                  subtitle: 'Blanc + Or',
                  index: 2,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.pureWhite,
                      AppColors.primaryGold.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantButton({
    required String title,
    required String subtitle,
    required int index,
    required Gradient gradient,
  }) {
    final isSelected = _selectedVariant == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedVariant = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Playfair',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: index == 2 ? AppColors.primaryBlack : AppColors.pureWhite,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                color: index == 2 ? AppColors.darkGray : AppColors.lightGray,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: AppColors.pureWhite,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDemoContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instructions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.pureWhite, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Instructions',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  '📱 Scrollez vers le haut pour voir l\'animation de l\'AppBar',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.pureWhite,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '🎨 Changez de variante avec les boutons ci-dessus',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.pureWhite,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '✨ Observez les transitions smooth et élégantes',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.pureWhite,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Caractéristiques
          const Text(
            'Caractéristiques',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlack,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            icon: Icons.animation,
            title: 'Animations Premium',
            description: 'Transitions fluides avec scale, fade et slide',
          ),
          
          _buildFeatureCard(
            icon: Icons.palette,
            title: 'Design Luxueux',
            description: 'Couleurs or, noir et blanc avec dégradés élégants',
          ),
          
          _buildFeatureCard(
            icon: Icons.touch_app,
            title: 'Interactions Smooth',
            description: 'Réactivité au scroll avec effets de parallaxe',
          ),
          
          _buildFeatureCard(
            icon: Icons.code,
            title: 'Code Réutilisable',
            description: 'Composants modulaires et faciles à intégrer',
          ),
          
          const SizedBox(height: 32),
          
          // Contenu de remplissage pour tester le scroll
          ...List.generate(
            5,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.mediumGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Section ${index + 1}',
                    style: const TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contenu de démonstration pour tester le scroll. '
                    'L\'AppBar s\'anime de manière élégante lors du défilement.',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: AppColors.darkGray,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mediumGray),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.pureWhite, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    color: AppColors.darkGray,
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
