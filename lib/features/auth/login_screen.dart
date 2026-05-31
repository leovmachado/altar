import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/auth_controller.dart';
import '../../core/design_system.dart';
import '../../core/localization/l10n_extension.dart';

/// Mock sign-in. Email/password, Google and Apple are all placeholders —
/// tapping any of them drops the reviewer into the demo as a mock user.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(text: 'marcus@altar.demo');
  final _password = TextEditingController(text: '••••••••');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _enter() => ref
      .read(authControllerProvider.notifier)
      .signInWithEmail(_email.text, _password.text);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final altar = context.altar;

    // Compact spacing on phones so the card fits a normal iPhone viewport
    // without scrolling. Desktop keeps the original, roomier spacing.
    final compact = !context.isDesktop;
    final outerPad = compact ? AppSpacing.md : AppSpacing.lg;
    final cardPad = compact ? AppSpacing.md : AppSpacing.lg;
    final gapSection = compact ? AppSpacing.sm : AppSpacing.lg; // big gaps
    final gapSocial = compact ? AppSpacing.md : AppSpacing.md;
    final logoSize = compact ? 34.0 : 40.0;

    final card = GlassCard(
      padding: EdgeInsets.all(cardPad),
      glow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: BrandLogo(size: logoSize)),
          SizedBox(height: gapSection),
          Text(l10n.authWelcome,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xxs),
          Text(l10n.authSubtitle,
              style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
          SizedBox(height: gapSection),
          _Field(
            label: l10n.authEmail,
            controller: _email,
            hint: l10n.authEmailHint,
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.sm),
          _Field(
            label: l10n.authPassword,
            controller: _password,
            icon: Icons.lock_outline_rounded,
            obscure: true,
          ),
          // Right-aligned "forgot password" — kept compact so it doesn't add
          // a full tap-target's worth of vertical space on phones.
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {},
              child: Text(l10n.authForgotPassword),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AltarButton(
            label: l10n.authSignIn,
            size: AltarButtonSize.large,
            expand: true,
            onPressed: _enter,
          ),
          SizedBox(height: gapSection),
          Row(
            children: [
              Expanded(child: Divider(color: altar.border)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(l10n.authOrContinueWith,
                    style: theme.textTheme.labelSmall),
              ),
              Expanded(child: Divider(color: altar.border)),
            ],
          ),
          SizedBox(height: gapSocial),
          _SocialButton(
            label: l10n.authGoogle,
            icon: Icons.g_mobiledata_rounded,
            onPressed: () => ref
                .read(authControllerProvider.notifier)
                .signInWithGoogle(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SocialButton(
            label: l10n.authApple,
            icon: Icons.apple_rounded,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signInWithApple(),
          ),
          SizedBox(height: gapSection),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: altar.info.withValues(alpha: 0.10),
              borderRadius: AppRadii.brSm,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: altar.info),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(l10n.authMockNotice,
                      style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlowBackground(
        child: SafeArea(
          // LayoutBuilder + minHeight lets the card center when it fits (so it
          // does NOT scroll on a normal iPhone) yet still scroll as an overflow
          // safety net on very small devices or when the keyboard is open —
          // guaranteeing there are never overflow errors.
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.all(outerPad),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - outerPad * 2,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: card,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.obscure = false,
  });
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AltarButton(
      label: label,
      icon: icon,
      variant: AltarButtonVariant.secondary,
      expand: true,
      onPressed: onPressed,
    );
  }
}
