import 'package:flutter/material.dart';

/// Encourage Typography System
/// Uses Space Grotesk for headlines/labels, Inter for body text
abstract final class AppTypography {
  static const String headlineFont = 'SpaceGrotesk';
  static const String bodyFont = 'Inter';

  // Headline XL - 48px / 56px / -0.02em / Bold 700
  static const TextStyle headlineXl = TextStyle(
    fontFamily: headlineFont,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.96, // -0.02em * 48px
  );

  // Headline XL Mobile - 32px / 38px / -0.01em / Bold 700
  static const TextStyle headlineXlMobile = TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 38 / 32,
    letterSpacing: -0.32, // -0.01em * 32px
  );

  // Headline LG - 32px / 40px / Bold 700
  static const TextStyle headlineLg = TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
  );

  // Headline MD - 24px / 32px / SemiBold 600
  static const TextStyle headlineMd = TextStyle(
    fontFamily: headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  // Body LG - 18px / 28px / Regular 400
  static const TextStyle bodyLg = TextStyle(
    fontFamily: bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 28 / 18,
  );

  // Body MD - 16px / 24px / Regular 400
  static const TextStyle bodyMd = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  // Label LG - 14px / 20px / Bold 700 (Space Grotesk)
  static const TextStyle labelLg = TextStyle(
    fontFamily: headlineFont,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
  );

  // Button - 16px / 20px / Bold 700 (Space Grotesk)
  static const TextStyle button = TextStyle(
    fontFamily: headlineFont,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 20 / 16,
  );

  // Label SM (for tags/chips uppercase)
  static const TextStyle labelSm = TextStyle(
    fontFamily: headlineFont,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
  );

  // Body SM
  static const TextStyle bodySm = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );
}
