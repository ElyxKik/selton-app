import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Écran de splash ultra-premium "Ethereal Gold"
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Durée calculée pour laisser le temps d'apprécier l'ambiance
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        children: [
          // 1. Fond avec Spotlight Radial (Effet de profondeur)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.5,
                  colors: [
                    AppColors.secondaryBlack, // Gris/Bleu foncé au centre
                    AppColors.primaryBlack, // Noir/Bleu nuit pur sur les bords
                  ],
                ),
              ),
            ),
          ),

          // 2. Particules d'Or (Gold Dust)
          const Positioned.fill(child: _GoldParticles()),

          // 3. Contenu Central
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo en Lévitation avec Aura
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Aura lumineuse derrière le logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGold.withOpacity(0.2),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.5, 1.5),
                        duration: const Duration(seconds: 3),
                        curve: Curves.easeInOut,
                      ),

                      // Logo
                      Image.asset(
                        'assets/images/logo_selton.png',
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: const Duration(seconds: 1), curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.0, 1.0),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutCubic,
                )
                .then()
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: -10,
                  duration: const Duration(seconds: 3),
                  curve: Curves.easeInOut,
                ), // Effet de flottement lent

                const SizedBox(height: 50),

                // Ligne Verticale Élégante
                Container(
                  width: 1,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryGold.withOpacity(0.0),
                        AppColors.primaryGold,
                        AppColors.primaryGold.withOpacity(0.0),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 500))
                .scaleY(
                  begin: 0,
                  end: 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                ),

                const SizedBox(height: 30),

                // Texte SELTON avec Gradient Doré
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AppColors.primaryGold, // Or Jaune
                      AppColors.primaryGoldLight, // Or Orange
                      AppColors.primaryGold,
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    'SELTON',
                    style: TextStyle(
                      fontFamily: 'Playfair',
                      fontSize: 42,
                      fontWeight: FontWeight.w500, // Plus fin = Plus luxe
                      color: Colors.white, // Requis pour le ShaderMask
                      letterSpacing: 12,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 800), duration: const Duration(seconds: 1))
                .custom(
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    // Animation subtile d'espacement des lettres (simulée par scale pour perf)
                    return Transform.scale(
                      scale: 1.0 + (0.1 * (1 - value)), // 1.1 -> 1.0
                      child: child,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Sous-titre
                Text(
                  'LUXURY HOTEL',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryGold.withOpacity(0.6),
                    letterSpacing: 6,
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 1200), duration: const Duration(seconds: 1))
                .slideY(begin: 0.2, end: 0, duration: const Duration(seconds: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour générer des particules dorées flottantes
class _GoldParticles extends StatelessWidget {
  const _GoldParticles();

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    return Stack(
      children: List.generate(15, (index) {
        final size = random.nextDouble() * 3 + 1; // Taille entre 1 et 4
        final left = random.nextDouble() * MediaQuery.of(context).size.width;
        final top = random.nextDouble() * MediaQuery.of(context).size.height;
        final duration = random.nextInt(3000) + 3000; // 3s à 6s

        return Positioned(
          left: left,
          top: top,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(random.nextDouble() * 0.3 + 0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGold.withOpacity(0.2),
                  blurRadius: 5,
                )
              ],
            ),
          )
          .animate(
            onPlay: (c) => c.repeat(),
          )
          .moveY(
            begin: 0,
            end: -100, // Monte doucement
            duration: Duration(milliseconds: duration),
          )
          .fadeIn(duration: const Duration(seconds: 1))
          .fadeOut(delay: Duration(milliseconds: duration - 1000), duration: const Duration(seconds: 1)),
        );
      }),
    );
  }
}
