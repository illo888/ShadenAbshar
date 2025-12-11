import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF0D7C66);
  static const primaryDark = Color(0xFF0A6B58);
  
  // Secondary Colors
  static const secondary = Color(0xFFFFB800);
  static const accent = Color(0xFF8B5CF6);
  
  // Status Colors
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  
  // Background Colors
  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const cardBg = Color(0xFFFFFFFF);
  
  // Text Colors
  static const text = Color(0xFF1A1A1A);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textDark = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Color(0xFF6B7280);
  static const textWhite = Color(0xFFFFFFFF);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF41B8A7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const accentGradient = LinearGradient(
    colors: [accent, Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Disable constructor
  const AppColors._();
}
