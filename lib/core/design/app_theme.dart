import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// Centralized Altar theme. Light mode is primary; dark mode is a complete
/// foundation. All screens read from these themes — no ad-hoc colors.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = const ColorScheme.light(
      primary: AppColors.teal,
      onPrimary: Colors.white,
      secondary: AppColors.aqua,
      onSecondary: Color(0xFF06251F),
      tertiary: AppColors.green,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightInk,
      error: AppColors.danger,
      outline: AppColors.lightBorder,
    );

    final text = AppTypography.build(
      AppColors.lightInk,
      AppColors.lightInkSecondary,
    );

    return _base(
      brightness: Brightness.light,
      scheme: scheme,
      text: text,
      scaffoldBackground: AppColors.lightBackground,
      altarColors: AltarColors.light,
      systemOverlay: SystemUiOverlayStyle.dark,
    );
  }

  static ThemeData get dark {
    final scheme = const ColorScheme.dark(
      primary: AppColors.aqua,
      onPrimary: Color(0xFF04231E),
      secondary: AppColors.teal,
      onSecondary: Colors.white,
      tertiary: AppColors.green,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkInk,
      error: AppColors.danger,
      outline: AppColors.darkBorder,
    );

    final text = AppTypography.build(
      AppColors.darkInk,
      AppColors.darkInkSecondary,
    );

    return _base(
      brightness: Brightness.dark,
      scheme: scheme,
      text: text,
      scaffoldBackground: AppColors.darkBackground,
      altarColors: AltarColors.dark,
      systemOverlay: SystemUiOverlayStyle.light,
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme scheme,
    required TextTheme text,
    required Color scaffoldBackground,
    required AltarColors altarColors,
    required SystemUiOverlayStyle systemOverlay,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: text,
      splashFactory: InkSparkle.splashFactory,
      extensions: [altarColors],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: systemOverlay,
        titleTextStyle: text.titleLarge,
        foregroundColor: scheme.onSurface,
      ),
      dividerTheme: DividerThemeData(
        color: altarColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: text.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: altarColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          textStyle: text.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: text.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: altarColors.surfaceMuted,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: text.bodyMedium?.copyWith(color: altarColors.inkTertiary),
        border: OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: altarColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: altarColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: altarColors.surfaceMuted,
        labelStyle: text.labelMedium,
        side: BorderSide(color: altarColors.border),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brSm),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.14),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.all(text.labelSmall),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        ),
      ),
    );
  }
}
