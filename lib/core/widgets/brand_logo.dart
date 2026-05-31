import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_tokens.dart';

/// Altar wordmark + glyph. The glyph is a stylized gradient "flame/altar"
/// rounded square; the wordmark uses the display font.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 28, this.showWordmark = true});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.brandGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: AppShadows.glow(
              AppColors.teal.withValues(alpha: 0.5),
              strength: 0.4,
            ),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: size * 0.56,
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Altar',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// Full-page "module coming in a later phase" placeholder.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    required this.title,
    required this.body,
    this.icon = Icons.rocket_launch_rounded,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.brandGradient
                        .map((c) => c.withValues(alpha: 0.16))
                        .toList(),
                  ),
                  borderRadius: AppRadii.brLg,
                ),
                child: Icon(icon, size: 36, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(title,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text(body,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
