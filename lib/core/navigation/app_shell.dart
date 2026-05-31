import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/auth_controller.dart';
import '../../app/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../core/rbac/app_role.dart';
import '../design_system.dart';
import '../localization/l10n_extension.dart';
import 'routes.dart';

/// Responsive application shell. Mobile shows a bottom navigation bar with the
/// 5 member tabs; desktop shows a glass side rail with the full operator menu.
/// The shell owns all chrome (background glow, app bar, rail) so feature
/// screens only render their body content.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlowBackground(
      child: ResponsiveBuilder(
        mobile: (_) => _MobileShell(location: location, child: child),
        desktop: (_) => _DesktopShell(location: location, child: child),
      ),
    );
  }
}

String _titleForLocation(String location, AppLocalizations l10n) {
  if (location.startsWith(Routes.home)) return l10n.navHome;
  if (location.startsWith(Routes.dashboard)) return l10n.navDashboard;
  if (location.startsWith(Routes.events)) return l10n.navEvents;
  if (location.startsWith(Routes.schedule)) return l10n.navSchedule;
  if (location.startsWith(Routes.giving)) return l10n.navGiving;
  if (location.startsWith(Routes.profile)) return l10n.navProfile;
  if (location.startsWith(Routes.people)) return l10n.navPeople;
  if (location.startsWith(Routes.visitorLeads)) return l10n.navVisitorLeads;
  if (location.startsWith(Routes.finance)) return l10n.navFinance;
  if (location.startsWith(Routes.media)) return l10n.navMedia;
  if (location.startsWith(Routes.reports)) return l10n.navReports;
  if (location.startsWith(Routes.settings)) return l10n.navSettings;
  return l10n.appName;
}

int _selectedMobileIndex(String location) {
  final i = kMobileDestinations.indexWhere((d) => location.startsWith(d.path));
  return i < 0 ? 0 : i;
}

// ---- Mobile -----------------------------------------------------------------
class _MobileShell extends ConsumerWidget {
  const _MobileShell({required this.child, required this.location});
  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: location.startsWith(Routes.home)
            ? const BrandLogo(size: 26)
            : Text(_titleForLocation(location, l10n)),
        actions: const [_DemoMenu(), SizedBox(width: 4)],
      ),
      body: SafeArea(top: false, child: child),
      bottomNavigationBar: _GlassBottomBar(location: location),
    );
  }
}

class _GlassBottomBar extends StatelessWidget {
  const _GlassBottomBar({required this.location});
  final String location;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: context.altar.border)),
      ),
      child: NavigationBar(
        selectedIndex: _selectedMobileIndex(location),
        onDestinationSelected: (i) =>
            context.go(kMobileDestinations[i].path),
        destinations: [
          for (final d in kMobileDestinations)
            NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon),
              label: d.labelFor(l10n),
            ),
        ],
      ),
    );
  }
}

// ---- Desktop ----------------------------------------------------------------
class _DesktopShell extends ConsumerWidget {
  const _DesktopShell({required this.child, required this.location});
  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rbac = ref.watch(rbacProvider);
    final destinations = kDesktopDestinations
        .where((d) => d.requires == null || rbac.can(d.requires!))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          _SideRail(location: location, destinations: destinations),
          Expanded(
            child: Column(
              children: [
                _DesktopTopBar(title: _titleForLocation(location, l10n)),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideRail extends StatelessWidget {
  const _SideRail({required this.location, required this.destinations});
  final String location;
  final List<NavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final l10n = context.l10n;

    return Container(
      width: 256,
      margin: const EdgeInsets.all(AppSpacing.sm),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.xs, AppSpacing.xs, 0, AppSpacing.lg),
              child: BrandLogo(size: 30),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final d in destinations)
                    _RailTile(
                      destination: d,
                      selected: location.startsWith(d.path),
                      label: d.labelFor(l10n),
                    ),
                ],
              ),
            ),
            Divider(color: altar.border, height: AppSpacing.lg),
            const _RailUserFooter(),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Text('Demo controls',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: altar.inkTertiary)),
                const Spacer(),
                const _DemoMenu(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RailTile extends StatelessWidget {
  const _RailTile({
    required this.destination,
    required this.selected,
    required this.label,
  });
  final NavDestination destination;
  final bool selected;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        selected ? theme.colorScheme.primary : context.altar.inkSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: AppRadii.brMd,
        child: InkWell(
          borderRadius: AppRadii.brMd,
          onTap: () => context.go(destination.path),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: 11),
            child: Row(
              children: [
                Icon(selected ? destination.selectedIcon : destination.icon,
                    size: 20, color: color),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: selected ? theme.colorScheme.onSurface : color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RailUserFooter extends ConsumerWidget {
  const _RailUserFooter();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final rbac = ref.watch(rbacProvider);
    final theme = Theme.of(context);
    if (user == null) return const SizedBox.shrink();
    return Row(
      children: [
        AltarAvatar(name: user.fullName, radius: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullName,
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis),
              Text(rbac.primaryRole.label(context.l10n),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: context.altar.inkTertiary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopTopBar extends StatelessWidget {
  const _DesktopTopBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.displaySmall),
          const Spacer(),
          SizedBox(
            width: 280,
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.actionSearch,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const _ThemeToggleButton(),
        ],
      ),
    );
  }
}

// ---- Shared demo / theme controls ------------------------------------------
class _ThemeToggleButton extends ConsumerWidget {
  const _ThemeToggleButton();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;
    return IconButton.filledTonal(
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
      icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          size: 20),
    );
  }
}

/// Popup giving reviewers quick control over the demo: switch role-tailored
/// dashboard, toggle theme, switch language, sign out.
class _DemoMenu extends ConsumerWidget {
  const _DemoMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.tune_rounded, size: 20),
      tooltip: 'Demo controls',
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
      onSelected: (value) {
        final auth = ref.read(authControllerProvider.notifier);
        switch (value) {
          case 'd_member':
            auth.previewDashboard(DashboardType.member);
          case 'd_volunteer':
            auth.previewDashboard(DashboardType.volunteer);
          case 'd_leader':
            auth.previewDashboard(DashboardType.ministryLeader);
          case 'd_pastor':
            auth.previewDashboard(DashboardType.leadPastor);
          case 'd_finance':
            auth.previewDashboard(DashboardType.financialLeader);
          case 'lang_en':
            ref.read(localeControllerProvider.notifier).setLocale(const Locale('en'));
          case 'lang_pt':
            ref.read(localeControllerProvider.notifier).setLocale(const Locale('pt'));
          case 'theme':
            ref.read(themeModeProvider.notifier).toggle();
          case 'signout':
            auth.signOut();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Text('PREVIEW DASHBOARD',
              style: Theme.of(context).textTheme.labelSmall),
        ),
        PopupMenuItem(value: 'd_member', child: Text(l10n.roleMember)),
        PopupMenuItem(value: 'd_volunteer', child: Text(l10n.roleVolunteer)),
        PopupMenuItem(value: 'd_leader', child: Text(l10n.roleMinistryLeader)),
        PopupMenuItem(value: 'd_pastor', child: Text(l10n.roleLeadPastor)),
        PopupMenuItem(value: 'd_finance', child: Text(l10n.roleFinancialLeader)),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'lang_en', child: Text(l10n.languageEnglish)),
        PopupMenuItem(value: 'lang_pt', child: Text(l10n.languagePortuguese)),
        PopupMenuItem(value: 'theme', child: Text('Toggle theme')),
        const PopupMenuDivider(),
        PopupMenuItem(value: 'signout', child: Text(l10n.profileSignOut)),
      ],
    );
  }
}
