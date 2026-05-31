import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Altar typography. Plus Jakarta Sans for display/headings (geometric, premium),
/// Inter for body/UI (highly legible). Tight tracking on large sizes for that
/// modern SaaS look.
class AppTypography {
  AppTypography._();

  static TextTheme build(Color ink, Color inkSecondary) {
    final display = GoogleFonts.plusJakartaSans;
    final body = GoogleFonts.inter;

    return TextTheme(
      displayLarge: display(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.05,
        color: ink,
      ),
      displayMedium: display(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
        color: ink,
      ),
      displaySmall: display(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
        color: ink,
      ),
      headlineMedium: display(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: ink,
      ),
      headlineSmall: display(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: ink,
      ),
      titleLarge: display(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: ink,
      ),
      titleMedium: body(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleSmall: body(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: body(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ink,
      ),
      bodyMedium: body(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: inkSecondary,
      ),
      bodySmall: body(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: inkSecondary,
      ),
      labelLarge: body(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: ink,
      ),
      labelMedium: body(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: inkSecondary,
      ),
      labelSmall: body(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: inkSecondary,
      ),
    );
  }
}
