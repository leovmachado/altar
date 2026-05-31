import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../rbac/permissions.dart';

/// All route paths in one place.
class Routes {
  Routes._();
  static const login = '/login';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const events = '/events';
  static const eventDetail = '/events/:id'; // param: id
  // The primary tab is the Ministry hub. The path keeps the `schedule` name
  // internally (routing/feature code is unchanged); only the label is "Ministry".
  static const schedule = '/schedule';
  static const fullSchedule = '/full-schedule'; // pushed: list + calendar
  static const ministryDetail = '/ministry/:id'; // param: id
  static const giving = '/giving';
  static const profile = '/profile';
  static const people = '/people';
  static const visitorLeads = '/visitor-leads';
  static const finance = '/finance';
  static const media = '/media';
  static const reports = '/reports';
  static const settings = '/settings';

  static String eventDetailFor(String id) => '/events/$id';
  static String ministryDetailFor(String id) => '/ministry/$id';
}

/// A destination shown in the mobile bottom bar or desktop side rail.
@immutable
class NavDestination {
  const NavDestination({
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.labelFor,
    this.requires,
  });

  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String Function(AppLocalizations) labelFor;

  /// Optional permission gate; null means always visible.
  final AppPermission? requires;
}

/// Mobile bottom-nav: Home · Events · Serving · Profile.
///
/// Giving is intentionally NOT in the primary navigation for now. Its route
/// (`Routes.giving`) and screen still exist as a hidden placeholder and remain
/// reachable from in-app cards.
final List<NavDestination> kMobileDestinations = [
  NavDestination(
    path: Routes.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    labelFor: (l) => l.navHome,
  ),
  NavDestination(
    path: Routes.events,
    icon: Icons.event_outlined,
    selectedIcon: Icons.event_rounded,
    labelFor: (l) => l.navEvents,
  ),
  NavDestination(
    path: Routes.schedule,
    icon: Icons.diversity_3_outlined,
    selectedIcon: Icons.diversity_3_rounded,
    labelFor: (l) => l.navSchedule,
  ),
  NavDestination(
    path: Routes.profile,
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    labelFor: (l) => l.navProfile,
  ),
];

/// Desktop side rail: Dashboard · People · Visitor Leads · Events · Serving ·
/// Finance · Media · Reports · Settings. Each gated by a permission.
/// (Giving is intentionally omitted from the primary navigation for now.)
final List<NavDestination> kDesktopDestinations = [
  NavDestination(
    path: Routes.dashboard,
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
    labelFor: (l) => l.navDashboard,
  ),
  NavDestination(
    path: Routes.people,
    icon: Icons.people_outline_rounded,
    selectedIcon: Icons.people_rounded,
    labelFor: (l) => l.navPeople,
    requires: AppPermission.managePeople,
  ),
  NavDestination(
    path: Routes.visitorLeads,
    icon: Icons.person_add_alt_outlined,
    selectedIcon: Icons.person_add_alt_1_rounded,
    labelFor: (l) => l.navVisitorLeads,
    requires: AppPermission.viewVisitorLeads,
  ),
  NavDestination(
    path: Routes.events,
    icon: Icons.event_outlined,
    selectedIcon: Icons.event_rounded,
    labelFor: (l) => l.navEvents,
  ),
  NavDestination(
    path: Routes.schedule,
    icon: Icons.diversity_3_outlined,
    selectedIcon: Icons.diversity_3_rounded,
    labelFor: (l) => l.navEscala,
  ),
  NavDestination(
    path: Routes.finance,
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
    labelFor: (l) => l.navFinance,
    requires: AppPermission.viewFinance,
  ),
  NavDestination(
    path: Routes.media,
    icon: Icons.play_circle_outline_rounded,
    selectedIcon: Icons.play_circle_rounded,
    labelFor: (l) => l.navMedia,
    requires: AppPermission.manageMedia,
  ),
  NavDestination(
    path: Routes.reports,
    icon: Icons.insights_outlined,
    selectedIcon: Icons.insights_rounded,
    labelFor: (l) => l.navReports,
    requires: AppPermission.viewReports,
  ),
  NavDestination(
    path: Routes.settings,
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    labelFor: (l) => l.navSettings,
    requires: AppPermission.manageSettings,
  ),
];
