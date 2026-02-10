import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Styles de texte premium pour l'application
class AppTextStyles {
  AppTextStyles._();
  
  // Titres - Playfair Display (élégant, serif)
  static TextStyle get h1 => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlack,
        height: 1.2,
        letterSpacing: -0.5,
      );
  
  static TextStyle get h2 => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlack,
        height: 1.3,
        letterSpacing: -0.3,
      );
  
  static TextStyle get h3 => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlack,
        height: 1.3,
      );
  
  static TextStyle get h4 => GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlack,
        height: 1.4,
      );
  
  // Corps de texte - Montserrat (moderne, sans-serif)
  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.primaryBlack,
        height: 1.5,
      );
  
  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.primaryBlack,
        height: 1.5,
      );
  
  static TextStyle get bodySmall => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.darkGray,
        height: 1.4,
      );
  
  // Boutons
  static TextStyle get button => GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );
  
  static TextStyle get buttonSmall => GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );
  
  // Labels et captions
  static TextStyle get label => GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.darkGray,
        letterSpacing: 0.3,
      );
  
  static TextStyle get caption => GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: AppColors.darkGray,
        letterSpacing: 0.2,
      );
  
  // Prix
  static TextStyle get price => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGold,
        letterSpacing: -0.5,
      );
  
  static TextStyle get priceSmall => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGold,
      );
}
