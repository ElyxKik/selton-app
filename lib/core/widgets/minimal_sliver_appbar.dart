import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

/// ✨ VARIANTE 3: BLANC + OR ULTRA CLEAN
/// AppBar minimaliste avec fond blanc, accents dorés et animations subtiles
class MinimalSliverAppBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSearchPressed;
  final bool showBackButton;

  const MinimalSliverAppBar({
    super.key,
    this.onMenuPressed,
    this.onSearchPressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      floating: false,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppColors.pureWhite,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      
      // Leading
      leading: _buildMinimalButton(
        icon: showBackButton ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
        onPressed: onMenuPressed ?? () => Navigator.of(context).maybePop(),
      ),
      
      // Actions
      actions: [
        _buildMinimalButton(
          icon: Icons.search_rounded,
          onPressed: onSearchPressed ?? () {},
        ),
        const SizedBox(width: 8),
      ],
      
      // FlexibleSpace
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        
        // Titre avec transition élégante
        title: LayoutBuilder(
          builder: (context, constraints) {
            final scrollRatio = _calculateScrollRatio(constraints);
            final isCollapsed = scrollRatio > 0.4;
            
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isCollapsed ? 1.0 : 0.0,
              child: _buildCollapsedTitle(scrollRatio),
            );
          },
        ),
        
        // Background ultra clean
        background: Container(
          color: AppColors.pureWhite,
          child: Stack(
            children: [
              // Dégradé subtil en haut
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryGold.withOpacity(0.03),
                        AppColors.pureWhite,
                      ],
                    ),
                  ),
                ),
              ),
              
              // Cercles décoratifs
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryGold.withOpacity(0.08),
                        AppColors.primaryGold.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryGold.withOpacity(0.05),
                        AppColors.primaryGold.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Contenu principal
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo minimaliste
                    _buildMinimalLogo(),
                    
                    const SizedBox(height: 32),
                    
                    // Nom élégant
                    _buildElegantTitle(),
                    
                    const SizedBox(height: 16),
                    
                    // Séparateur minimaliste
                    _buildMinimalDivider(),
                    
                    const SizedBox(height: 16),
                    
                    // Tagline
                    _buildTagline(),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
      ),
    );
  }

  Widget _buildMinimalButton({required IconData icon, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryGold.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(icon, color: AppColors.primaryGold, size: 20),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildCollapsedTitle(double scrollRatio) {
    return Transform.scale(
      scale: 0.85 + (scrollRatio * 0.15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo mini
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withOpacity(0.2),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Titre
          const Text(
            'SELTON',
            style: TextStyle(
              fontFamily: 'Playfair',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlack,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.7 + (value * 0.3),
          child: Opacity(
            opacity: value,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Effet de shine
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CustomPaint(
                        painter: _ShinePainter(animationValue: value),
                      ),
                    ),
                  ),
                  // Lettre S
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryGold,
                          AppColors.primaryGold.withOpacity(0.7),
                        ],
                      ).createShader(bounds),
                      child: const Text(
                        'S',
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildElegantTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Column(
              children: [
                // Nom principal
                Text(
                  'SELTON',
                  style: TextStyle(
                    fontFamily: 'Playfair',
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlack,
                    letterSpacing: 12,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryGold.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Sous-nom
                Text(
                  'HOTEL',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primaryGold,
                    letterSpacing: 6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMinimalDivider() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return SizedBox(
          width: 120 * value,
          height: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primaryGold,
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Where Elegance Meets Comfort',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGray,
              letterSpacing: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
    );
  }

  double _calculateScrollRatio(BoxConstraints constraints) {
    const expandedHeight = 320.0;
    const collapsedHeight = 56.0;
    final currentHeight = constraints.maxHeight;
    
    if (currentHeight >= expandedHeight) return 0.0;
    if (currentHeight <= collapsedHeight) return 1.0;
    
    return 1 - ((currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight));
  }
}

/// Painter pour effet de brillance
class _ShinePainter extends CustomPainter {
  final double animationValue;

  _ShinePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryGold.withOpacity(0.1 * animationValue),
          Colors.transparent,
          AppColors.primaryGold.withOpacity(0.05 * animationValue),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.7, 0)
      ..lineTo(size.width * 0.3, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ShinePainter oldDelegate) => 
      oldDelegate.animationValue != animationValue;
}
