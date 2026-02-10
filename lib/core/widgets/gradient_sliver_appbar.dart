import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// 🌟 VARIANTE 2: DÉGRADÉ PREMIUM
/// AppBar avec dégradé animé et effets de parallaxe
class GradientSliverAppBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final bool showBackButton;

  const GradientSliverAppBar({
    super.key,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      
      // Leading
      leading: _buildGlassButton(
        icon: showBackButton ? Icons.arrow_back_ios_new_rounded : Icons.menu_rounded,
        onPressed: onMenuPressed ?? () => Navigator.of(context).maybePop(),
      ),
      
      // Actions
      actions: [
        _buildGlassButton(
          icon: Icons.notifications_outlined,
          onPressed: onNotificationPressed ?? () {},
        ),
        const SizedBox(width: 8),
      ],
      
      // FlexibleSpace avec dégradé animé
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        
        // Titre animé
        title: LayoutBuilder(
          builder: (context, constraints) {
            final scrollRatio = _calculateScrollRatio(constraints);
            final isCollapsed = scrollRatio > 0.5;
            
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isCollapsed
                  ? _buildCollapsedTitle()
                  : const SizedBox.shrink(),
            );
          },
        ),
        
        // Background avec dégradé et parallaxe
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Dégradé principal
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlack, // Bleu nuit profond
                    AppColors.secondaryBlack, // Bleu un peu plus clair
                    AppColors.secondaryBlack.withOpacity(0.8), // Variante intermédiaire
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            
            // Overlay avec effet de lumière
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.5,
                    colors: [
                      AppColors.primaryGold.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // Particules dorées animées
            Positioned.fill(
              child: CustomPaint(
                painter: _GoldenParticlesPainter(),
              ),
            ),
            
            // Contenu principal avec parallaxe
            LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      
                      // Logo avec effet de brillance
                      _buildAnimatedLogo(),
                      
                      const SizedBox(height: 28),
                      
                      // Nom avec effet de fade
                      _buildAnimatedTitle(),
                      
                      const SizedBox(height: 12),
                      
                      // Ligne décorative
                      _buildDecorativeLine(),
                      
                      const SizedBox(height: 12),
                      
                      // Sous-titre
                      _buildSubtitle(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
      ),
    );
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon, color: AppColors.primaryGold, size: 22),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _buildCollapsedTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        'SELTON',
        style: TextStyle(
          fontFamily: 'Playfair',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.pureWhite,
          letterSpacing: 4,
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.5 + (value * 0.5),
          child: Transform.rotate(
            angle: (1 - value) * 0.5,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Effet de brillance
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Lettre S
                  const Center(
                    child: Text(
                      'S',
                      style: TextStyle(
                        fontFamily: 'Playfair',
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pureWhite,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
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

  Widget _buildAnimatedTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.primaryGold,
                  AppColors.primaryGold.withOpacity(0.8),
                  AppColors.pureWhite,
                ],
              ).createShader(bounds),
              child: const Text(
                'SELTON',
                style: TextStyle(
                  fontFamily: 'Playfair',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pureWhite,
                  letterSpacing: 10,
                  shadows: [
                    Shadow(
                      color: AppColors.primaryGold,
                      blurRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecorativeLine() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return SizedBox(
          width: 200 * value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.primaryGold.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGold.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: const Text(
            'E X P E R I E N C E  •  L U X U R Y',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: AppColors.lightGray,
              letterSpacing: 3,
            ),
          ),
        );
      },
    );
  }

  double _calculateScrollRatio(BoxConstraints constraints) {
    const expandedHeight = 300.0;
    const collapsedHeight = 56.0;
    final currentHeight = constraints.maxHeight;
    
    if (currentHeight >= expandedHeight) return 0.0;
    if (currentHeight <= collapsedHeight) return 1.0;
    
    return 1 - ((currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight));
  }
}

/// Painter pour particules dorées
class _GoldenParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGold.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dessiner des points aléatoires
    for (var i = 0; i < 30; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 53) % size.height;
      final radius = (i % 3) + 1.0;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
