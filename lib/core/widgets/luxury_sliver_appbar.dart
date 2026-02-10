import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// 🏆 VARIANTE 1: LUXE (Noir + Or)
/// AppBar premium avec fond noir, accents dorés et animations élégantes
class LuxurySliverAppBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onProfilePressed;
  final bool showBackButton;

  const LuxurySliverAppBar({
    super.key,
    this.onMenuPressed,
    this.onProfilePressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppColors.primaryBlack,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      
      // Leading - Menu ou Back
      leading: _buildLeadingButton(context),
      
      // Actions - Profile/Notifications
      actions: [
        _buildActionButton(context),
      ],
      
      // FlexibleSpace avec animations
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        
        // Titre avec animation
        title: LayoutBuilder(
          builder: (context, constraints) {
            // Calcul du ratio de scroll (0.0 = expanded, 1.0 = collapsed)
            final scrollRatio = _calculateScrollRatio(constraints);
            
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: scrollRatio > 0.5 ? 1.0 : 0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo mini
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Titre
                  const Text(
                    'SELTON',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        // Background avec logo large
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBlack,
                AppColors.primaryBlack.withOpacity(0.95),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Pattern décoratif subtil
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: CustomPaint(
                    painter: _LuxuryPatternPainter(),
                  ),
                ),
              ),
              
              // Contenu principal
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Logo large avec animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryGold.withOpacity(0.4),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'S',
                                style: TextStyle(
                                  fontFamily: 'Playfair',
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Nom de l'hôtel avec animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: const Text(
                              'SELTON',
                              style: TextStyle(
                                fontFamily: 'Playfair',
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGold,
                                letterSpacing: 8,
                                shadows: [
                                  Shadow(
                                    color: AppColors.primaryGold,
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Sous-titre
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: const Text(
                            'LUXURY HOTEL',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.lightGray,
                              letterSpacing: 4,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Animation de stretch
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryGold.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            showBackButton ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
            color: AppColors.primaryGold,
            size: 20,
          ),
          onPressed: onMenuPressed ?? () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryGold.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primaryGold,
            size: 20,
          ),
          onPressed: onProfilePressed ?? () {},
        ),
      ),
    );
  }

  double _calculateScrollRatio(BoxConstraints constraints) {
    const expandedHeight = 280.0;
    const collapsedHeight = 56.0;
    final currentHeight = constraints.maxHeight;
    
    if (currentHeight >= expandedHeight) return 0.0;
    if (currentHeight <= collapsedHeight) return 1.0;
    
    return 1 - ((currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight));
  }
}

/// Pattern painter pour effet décoratif
class _LuxuryPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Lignes diagonales décoratives
    for (var i = 0; i < 10; i++) {
      final x = size.width * i / 10;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
