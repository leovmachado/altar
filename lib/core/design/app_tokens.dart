import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing scale (4pt grid). Use these constants instead of magic numbers.
class AppSpacing {
  AppSpacing._();
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const EdgeInsets pagePadding = EdgeInsets.all(md);
  static const EdgeInsets pagePaddingWide = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: lg,
  );
}

/// Corner radii — generous, rounded, premium.
class AppRadii {
  AppRadii._();
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 999;

  static const Radius rMd = Radius.circular(md);
  static const Radius rLg = Radius.circular(lg);

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
}

/// Soft shadows + brand glow accents. Subtle, layered, never harsh.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft({bool dark = false}) => [
        BoxShadow(
          color: dark
              ? Colors.black.withValues(alpha: 0.40)
              : const Color(0xFF0B1620).withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 10),
          spreadRadius: -6,
        ),
        BoxShadow(
          color: dark
              ? Colors.black.withValues(alpha: 0.25)
              : const Color(0xFF0B1620).withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> glow(Color color, {double strength = 0.45}) => [
        BoxShadow(
          color: color.withValues(alpha: strength),
          blurRadius: 36,
          offset: const Offset(0, 12),
          spreadRadius: -8,
        ),
      ];

  static List<BoxShadow> brandGlow = [
    BoxShadow(
      color: AppColors.teal.withValues(alpha: 0.35),
      blurRadius: 40,
      offset: const Offset(0, 16),
      spreadRadius: -10,
    ),
  ];
}

/// Animation timings for consistent motion.
class AppMotion {
  AppMotion._();
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Curve curve = Curves.easeOutCubic;
}
