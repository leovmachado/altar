import 'dart:ui';
import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_tokens.dart';

/// The signature Altar surface: frosted glass with a soft blur, hairline
/// border, rounded corners and a gentle drop shadow. Optionally tappable.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius = AppRadii.brLg,
    this.onTap,
    this.blur = 18,
    this.glow = false,
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final double blur;

  /// Adds a subtle brand glow shadow when true.
  final bool glow;

  /// Optional gradient fill (e.g. for hero / CTA cards).
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final altar = context.altar;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: gradient == null ? altar.glassFill : null,
            gradient: gradient,
            borderRadius: borderRadius,
            border: Border.all(color: altar.glassBorder, width: 1),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    final shadowed = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: glow
            ? AppShadows.glow(altar.glowColor, strength: 0.5)
            : AppShadows.soft(dark: isDark),
      ),
      child: card,
    );

    if (onTap == null) return shadowed;
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        splashColor: AppColors.teal.withValues(alpha: 0.06),
        highlightColor: AppColors.teal.withValues(alpha: 0.04),
        onTap: onTap,
        child: shadowed,
      ),
    );
  }
}
