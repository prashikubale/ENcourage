import 'package:flutter/material.dart';

/// Encourage App Color Palette
/// Based on the Cartoonish Brutalism design system from reference/DESIGN.md
abstract final class AppColors {
  // Primary
  static const Color primary = Color(0xFF1A58B7);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF3D72D2);
  static const Color onPrimaryContainer = Color(0xFFFEFCFF);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFAEC6FF);
  static const Color onPrimaryFixed = Color(0xFF001A43);
  static const Color onPrimaryFixedVariant = Color(0xFF004397);
  static const Color inversePrimary = Color(0xFFAEC6FF);

  // Secondary
  static const Color secondary = Color(0xFF725C00);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFED000);
  static const Color onSecondaryContainer = Color(0xFF6F5900);
  static const Color secondaryFixed = Color(0xFFFFE07F);
  static const Color secondaryFixedDim = Color(0xFFEDC200);
  static const Color onSecondaryFixed = Color(0xFF231B00);
  static const Color onSecondaryFixedVariant = Color(0xFF564500);

  // Tertiary
  static const Color tertiary = Color(0xFFAA2D32);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFCC4548);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);
  static const Color tertiaryFixed = Color(0xFFFFDAD8);
  static const Color tertiaryFixedDim = Color(0xFFFFB3B0);
  static const Color onTertiaryFixed = Color(0xFF410006);
  static const Color onTertiaryFixedVariant = Color(0xFF8C1520);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface / Background
  static const Color surface = Color(0xFFF9F9F9);
  static const Color surfaceDim = Color(0xFFDADADA);
  static const Color surfaceBright = Color(0xFFF9F9F9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F3F3);
  static const Color surfaceContainer = Color(0xFFEEEEEE);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E2);
  static const Color surfaceVariant = Color(0xFFE2E2E2);
  static const Color onSurface = Color(0xFF1B1B1B);
  static const Color onSurfaceVariant = Color(0xFF424752);
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF1F1F1);

  // Outline
  static const Color outline = Color(0xFF737784);
  static const Color outlineVariant = Color(0xFFC3C6D4);

  // Background
  static const Color background = Color(0xFFF9F9F9);
  static const Color onBackground = Color(0xFF1B1B1B);

  // Misc
  static const Color surfaceTint = Color(0xFF1E5BBA);

  // Design System Accent (from DESIGN.md brand section)
  static const Color brandPrimary = Color(0xFF5B8DEF);
  static const Color brandSecondary = Color(0xFFFFD100);
  static const Color brandTertiary = Color(0xFFFF6B6B);

  // Hard shadow color (Neo-brutalist)
  static const Color shadow = Color(0xFF000000);
}
