import 'package:flutter/material.dart';

/// Altar brand palette — teal / aqua / green, tuned for a premium SaaS feel
/// inspired by Linear, Stripe, Notion and Apple.
///
/// Colors are exposed as raw brand tokens plus light/dark semantic sets.
/// Widgets should prefer reading semantic colors from `Theme.of(context)`
/// or the [AltarColors] extension rather than these raw tokens directly.
class AppColors {
  AppColors._();

  // ---- Brand ----------------------------------------------------------------
  static const Color teal = Color(0xFF0FB5A6);
  static const Color tealDeep = Color(0xFF0A867C);
  static const Color aqua = Color(0xFF2DD4BF);
  static const Color green = Color(0xFF10B981);
  static const Color mint = Color(0xFF6EE7D2);

  /// Signature brand gradient used on hero surfaces, CTAs and glows.
  static const List<Color> brandGradient = [teal, aqua, green];

  // ---- Light neutrals (cool slate) -----------------------------------------
  static const Color lightBackground = Color(0xFFF1F5F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceMuted = Color(0xFFF6F9FA);
  static const Color lightBorder = Color(0xFFE2EAED);
  static const Color lightInk = Color(0xFF0B1620);
  static const Color lightInkSecondary = Color(0xFF556873);
  static const Color lightInkTertiary = Color(0xFF8CA0AB);

  // ---- Dark neutrals --------------------------------------------------------
  static const Color darkBackground = Color(0xFF060D12);
  static const Color darkSurface = Color(0xFF0E1A21);
  static const Color darkSurfaceMuted = Color(0xFF13222B);
  static const Color darkBorder = Color(0xFF1E2F38);
  static const Color darkInk = Color(0xFFEAF2F4);
  static const Color darkInkSecondary = Color(0xFF9FB2BC);
  static const Color darkInkTertiary = Color(0xFF6A7E89);

  // ---- Status ---------------------------------------------------------------
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF5A524);
  static const Color danger = Color(0xFFF4496D);
  static const Color info = Color(0xFF38BDF8);
}

/// Semantic color set surfaced through a [ThemeExtension] so screens can read
/// brand-aware glass / glow / border tokens regardless of brightness.
@immutable
class AltarColors extends ThemeExtension<AltarColors> {
  const AltarColors({
    required this.brandGradient,
    required this.glassFill,
    required this.glassBorder,
    required this.glowColor,
    required this.surfaceMuted,
    required this.border,
    required this.inkSecondary,
    required this.inkTertiary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
  });

  final List<Color> brandGradient;
  final Color glassFill;
  final Color glassBorder;
  final Color glowColor;
  final Color surfaceMuted;
  final Color border;
  final Color inkSecondary;
  final Color inkTertiary;
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;

  static const AltarColors light = AltarColors(
    brandGradient: AppColors.brandGradient,
    glassFill: Color(0xCCFFFFFF),
    glassBorder: Color(0x33FFFFFF),
    glowColor: Color(0x330FB5A6),
    surfaceMuted: AppColors.lightSurfaceMuted,
    border: AppColors.lightBorder,
    inkSecondary: AppColors.lightInkSecondary,
    inkTertiary: AppColors.lightInkTertiary,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    info: AppColors.info,
  );

  static const AltarColors dark = AltarColors(
    brandGradient: AppColors.brandGradient,
    glassFill: Color(0x1AFFFFFF),
    glassBorder: Color(0x24FFFFFF),
    glowColor: Color(0x402DD4BF),
    surfaceMuted: AppColors.darkSurfaceMuted,
    border: AppColors.darkBorder,
    inkSecondary: AppColors.darkInkSecondary,
    inkTertiary: AppColors.darkInkTertiary,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    info: AppColors.info,
  );

  @override
  AltarColors copyWith({
    List<Color>? brandGradient,
    Color? glassFill,
    Color? glassBorder,
    Color? glowColor,
    Color? surfaceMuted,
    Color? border,
    Color? inkSecondary,
    Color? inkTertiary,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
  }) {
    return AltarColors(
      brandGradient: brandGradient ?? this.brandGradient,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      glowColor: glowColor ?? this.glowColor,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      border: border ?? this.border,
      inkSecondary: inkSecondary ?? this.inkSecondary,
      inkTertiary: inkTertiary ?? this.inkTertiary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
    );
  }

  @override
  AltarColors lerp(ThemeExtension<AltarColors>? other, double t) {
    if (other is! AltarColors) return this;
    return AltarColors(
      brandGradient: brandGradient,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
      inkTertiary: Color.lerp(inkTertiary, other.inkTertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

/// Convenience accessor: `context.altar` returns the [AltarColors] extension.
extension AltarColorsX on BuildContext {
  AltarColors get altar => Theme.of(this).extension<AltarColors>()!;
}
