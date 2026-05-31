import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/design_system.dart';
import '../../core/localization/l10n_extension.dart';

/// Lightweight settings: language and appearance. Demonstrates the live
/// localization + theme foundation. Other settings are deferred.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = ref.watch(localeControllerProvider);
    final mode = ref.watch(themeModeProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ContentBounds(
          maxWidth: 720,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(title: l10n.profileLanguage, icon: Icons.translate_rounded),
              GlassCard(
                child: Column(
                  children: [
                    _Choice(
                      label: l10n.languageSystem,
                      selected: locale == null,
                      onTap: () => ref
                          .read(localeControllerProvider.notifier)
                          .setLocale(null),
                    ),
                    Divider(color: context.altar.border, height: AppSpacing.md),
                    _Choice(
                      label: l10n.languageEnglish,
                      selected: locale?.languageCode == 'en',
                      onTap: () => ref
                          .read(localeControllerProvider.notifier)
                          .setLocale(const Locale('en')),
                    ),
                    Divider(color: context.altar.border, height: AppSpacing.md),
                    _Choice(
                      label: l10n.languagePortuguese,
                      selected: locale?.languageCode == 'pt',
                      onTap: () => ref
                          .read(localeControllerProvider.notifier)
                          .setLocale(const Locale('pt')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: l10n.navSettings, icon: Icons.palette_outlined),
              GlassCard(
                child: Row(
                  children: [
                    Icon(Icons.dark_mode_rounded,
                        size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: Text('Dark mode',
                            style: theme.textTheme.titleMedium)),
                    Switch(
                      value: mode == ThemeMode.dark,
                      onChanged: (_) =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: AppRadii.brSm,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.titleMedium)),
            if (selected)
              Icon(Icons.check_circle_rounded,
                  color: theme.colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
