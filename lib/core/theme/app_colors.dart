import 'package:flutter/material.dart';

/// Palette de couleurs premium pour l'hôtel Selton
class AppColors {
  AppColors._();
  
  // Couleurs principales - Or et luxe (Beige/Doré #ccad79)
  static const Color primaryGold = Color(0xFFCCAD79);
  static const Color primaryGoldDark = Color(0xFFAA8C58); // Version plus sombre
  static const Color primaryGoldLight = Color(0xFFE6D0AA); // Version plus claire
  
  // Couleurs statuts
  static const Color platinum = Color(0xFFE5E4E2);
  
  // Fond et surfaces (Bleu nuit #1a2850)
  static const Color primaryBlack = Color(0xFF1A2850);
  static const Color secondaryBlack = Color(0xFF253665); // Version plus claire pour les cartes
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF757575);
  
  // Blanc
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  
  // Couleurs d'accent
  static const Color accentRose = Color(0xFFFFE5E5);
  static const Color accentBlue = Color(0xFF1E3A5F);
  static const Color accentGreen = Color(0xFF2E7D32);
  
  // États
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
  
  // Dégradés
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, primaryGoldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [primaryBlack, secondaryBlack],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF1A2850), Color(0xFF253665), Color(0xFF1A2850)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Overlay
  static Color overlay(double opacity) => primaryBlack.withOpacity(opacity);
}
