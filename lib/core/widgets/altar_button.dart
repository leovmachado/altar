import 'package:flutter/material.dart';
import '../design/app_colors.dart';
import '../design/app_tokens.dart';

enum AltarButtonVariant { primary, secondary, ghost }
enum AltarButtonSize { regular, large }

/// Primary action button. The [AltarButtonVariant.primary] variant uses the
/// brand gradient with a soft glow — the hero CTA across Altar.
class AltarButton extends StatelessWidget {
  const AltarButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AltarButtonVariant.primary,
    this.size = AltarButtonSize.regular,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AltarButtonVariant variant;
  final AltarButtonSize size;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final vPad = size == AltarButtonSize.large ? 18.0 : 14.0;

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.labelLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    switch (variant) {
      case AltarButtonVariant.primary:
        return _Glowing(
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.brandGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadii.brMd,
              boxShadow: onPressed == null ? null : AppShadows.brandGlow,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: vPad),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: IconTheme.merge(
                  data: const IconThemeData(color: Colors.white),
                  child: content,
                ),
              ),
            ),
          ),
        );
      case AltarButtonVariant.secondary:
        return _Glowing(
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadii.brMd,
              border: Border.all(color: altar.border),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: vPad),
              child: content,
            ),
          ),
        );
      case AltarButtonVariant.ghost:
        return _Glowing(
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: vPad),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: theme.colorScheme.primary),
              child: IconTheme.merge(
                data: IconThemeData(color: theme.colorScheme.primary),
                child: content,
              ),
            ),
          ),
        );
    }
  }
}

class _Glowing extends StatelessWidget {
  const _Glowing({required this.child, this.onPressed});
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.brMd,
        child: InkWell(
          borderRadius: AppRadii.brMd,
          onTap: onPressed,
          child: child,
        ),
      ),
    );
  }
}
