import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color neutralLight = Color(0xFFE5E5E5);

  static const Color specialGrey = Color(0xFF81887B);
  static const Color gardenStone = Color(0xFF949489);
  static const Color black = Color(0xFF1B2727);
  static const Color grey = Color(0xFF2D2D2D);
  static const Color lightGrey = Color(0xFFEAEAEA);

  // Green palette
  static const Color darkForestGreen = Color(0xFF235D3A);
  static const Color mediumDarkGreen = Color(0xFF397D54);
  static const Color mediumGreen = Color(0xFF73C088);
  static const Color lightMintGreen = Color(0xFFA8E0B7);
  static const Color paleGreen = Color(0xFFC8EAD1);

  // Accent
  static const Color gold = Color(0xFFFFD400);
  // Neumorphic
  static const Color neumorphBg = Color(0xFFECF0F3);
  static const Color neumorphHighlight = Color(0xFFFFFFFF);
  static const Color neumorphShadow = Color(0xFFD1D9E6);

  // Legacy aliases (for backward compatibility)
  static const Color primaryGreen = darkForestGreen;
  static const Color primaryGreenLight = mediumGreen;
}
