import 'package:flutter/material.dart';
import '../design/app_colors.dart';

/// Ambient background with soft brand-colored radial glows. Sits behind the
/// app content to give the premium "aurora" feel. Pure decoration.
class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key, required this.child, this.intensity = 1.0});

  final Widget child;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Theme.of(context).scaffoldBackgroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(color: base),
      child: Stack(
        // `child` is a NON-positioned child so the Stack sizes to it (and, with
        // StackFit.expand, the child is forced to fill the incoming bounded
        // constraints). The glow blobs are Positioned, so they're painted
        // behind the content without affecting layout. If `child` were
        // Positioned.fill too, a Stack of only-positioned children can collapse
        // to zero height under loose constraints (e.g. a Scaffold body) — which
        // would stop a CustomScrollView's slivers from ever laying out.
        fit: StackFit.expand,
        children: [
          // Top-right teal/aqua glow.
          Positioned(
            top: -160,
            right: -120,
            child: _Blob(
              color: AppColors.aqua
                  .withValues(alpha: (isDark ? 0.18 : 0.22) * intensity),
              size: 420,
            ),
          ),
          // Bottom-left green glow.
          Positioned(
            bottom: -180,
            left: -140,
            child: _Blob(
              color: AppColors.green
                  .withValues(alpha: (isDark ? 0.14 : 0.16) * intensity),
              size: 460,
            ),
          ),
          // Center teal wash.
          Positioned(
            top: 120,
            left: -60,
            child: _Blob(
              color: AppColors.teal
                  .withValues(alpha: (isDark ? 0.10 : 0.10) * intensity),
              size: 320,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}
