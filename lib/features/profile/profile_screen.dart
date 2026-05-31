import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/app/providers.dart';
import 'package:altar/app/auth_controller.dart';
import 'package:altar/data/models/models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final locale = ref.watch(localeControllerProvider);

    if (user == null) {
      return Center(
        child: EmptyState(
          title: context.l10n.profileTitle,
          message: context.l10n.profileTitle,
          icon: Icons.person_outline,
        ),
      );
    }

    final sections = <Widget>[
      _ProfileHeader(user: user),
      const SizedBox(height: AppSpacing.lg),
      _MinistriesSection(ministries: user.ministries),
      _FamilySection(family: user.family),
      _LanguageSection(activeLanguageCode: locale?.languageCode),
      const SizedBox(height: AppSpacing.lg),
      const _SettingsSection(),
      const SizedBox(height: AppSpacing.lg),
      const _SignOutButton(),
    ];

    final body = ListView(
      padding: AppSpacing.pagePadding,
      children: sections,
    );

    if (context.isDesktop) {
      return ContentBounds(maxWidth: 820, child: body);
    }
    return body;
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final altar = context.altar;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AltarAvatar(
                name: user.fullName,
                imageUrl: user.avatarUrl,
                radius: 36,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      user.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: altar.inkSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.profileMemberSince(user.memberSince),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: altar.inkTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.profileRoles,
            style: theme.textTheme.labelLarge?.copyWith(
              color: altar.inkSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final role in user.roles)
                StatusBadge(role.label(l10n), tone: BadgeTone.brand),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AltarButton(
            label: l10n.profileEdit,
            icon: Icons.edit_outlined,
            variant: AltarButtonVariant.secondary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MinistriesSection extends StatelessWidget {
  const _MinistriesSection({required this.ministries});

  final List<Ministry> ministries;

  @override
  Widget build(BuildContext context) {
    if (ministries.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final altar = context.altar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.profileMinistries),
        const SizedBox(height: AppSpacing.sm),
        GlassCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.md,
          ),
          child: Column(
            children: [
              for (var i = 0; i < ministries.length; i++) ...[
                if (i > 0) Divider(height: 1, color: altar.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(ministries[i].icon, color: AppColors.teal),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ministries[i].name,
                              style: theme.textTheme.titleMedium,
                            ),
                            if (ministries[i].role != null)
                              Text(
                                ministries[i].role!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: altar.inkSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _FamilySection extends StatelessWidget {
  const _FamilySection({required this.family});

  final List<FamilyMember> family;

  @override
  Widget build(BuildContext context) {
    if (family.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final altar = context.altar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.profileFamily),
        const SizedBox(height: AppSpacing.sm),
        GlassCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.md,
          ),
          child: Column(
            children: [
              for (var i = 0; i < family.length; i++) ...[
                if (i > 0) Divider(height: 1, color: altar.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      AltarAvatar(
                        name: family[i].name,
                        imageUrl: family[i].avatarUrl,
                        radius: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              family[i].name,
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              family[i].relationship,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: altar.inkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection({required this.activeLanguageCode});

  final String? activeLanguageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final altar = context.altar;

    void setLocale(Locale? locale) {
      ref.read(localeControllerProvider.notifier).setLocale(locale);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.profileLanguage),
        const SizedBox(height: AppSpacing.sm),
        GlassCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.md,
          ),
          child: Column(
            children: [
              _LanguageRow(
                label: l10n.languageEnglish,
                selected: activeLanguageCode == 'en',
                onTap: () => setLocale(const Locale('en')),
              ),
              Divider(height: 1, color: altar.border),
              _LanguageRow(
                label: l10n.languagePortuguese,
                selected: activeLanguageCode == 'pt',
                onTap: () => setLocale(const Locale('pt')),
              ),
              Divider(height: 1, color: altar.border),
              _LanguageRow(
                label: l10n.languageSystem,
                selected: activeLanguageCode == null,
                onTap: () => setLocale(null),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: AppRadii.brMd,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: theme.textTheme.titleMedium),
            ),
            if (selected) Icon(Icons.check_rounded, color: AppColors.teal),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final altar = context.altar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.profileSettings),
        const SizedBox(height: AppSpacing.sm),
        GlassCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.md,
          ),
          child: Column(
            children: [
              _SettingsRow(
                icon: Icons.notifications_outlined,
                label: l10n.profileNotifications,
              ),
              Divider(height: 1, color: altar.border),
              _SettingsRow(
                icon: Icons.lock_outline,
                label: l10n.profilePrivacy,
              ),
              Divider(height: 1, color: altar.border),
              _SettingsRow(
                icon: Icons.help_outline,
                label: l10n.profileHelp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    return InkWell(
      borderRadius: AppRadii.brMd,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, color: altar.inkSecondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: theme.textTheme.titleMedium),
            ),
            Icon(Icons.chevron_right_rounded, color: altar.inkTertiary),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AltarButton(
      label: context.l10n.profileSignOut,
      icon: Icons.logout_rounded,
      variant: AltarButtonVariant.secondary,
      expand: true,
      onPressed: () {
        ref.read(authControllerProvider.notifier).signOut();
      },
    );
  }
}
