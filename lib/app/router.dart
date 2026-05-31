import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/navigation/app_shell.dart';
import '../core/navigation/routes.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/events/event_detail_screen.dart';
import '../features/events/events_screen.dart';
import '../features/giving/giving_screen.dart';
import '../features/home/home_screen.dart';
import '../features/placeholders/placeholder_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/settings/settings_screen.dart';
import 'auth_controller.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

/// App router. Redirects to /login when signed out; otherwise renders the
/// responsive [AppShell] around each top-level destination.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: const String.fromEnvironment('START_ROUTE',
        defaultValue: Routes.home),
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final signedIn = auth.isSignedIn;
      final loggingIn = state.matchedLocation == Routes.login;
      if (!signedIn) return loggingIn ? null : Routes.login;
      if (loggingIn) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (_, _) => const LoginScreen(),
      ),
      // Event detail is pushed full-screen (own Scaffold), outside the shell.
      GoRoute(
        path: Routes.eventDetail,
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            EventDetailScreen(eventId: state.pathParameters['id'] ?? ''),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
          GoRoute(
              path: Routes.dashboard,
              builder: (_, _) => const DashboardScreen()),
          GoRoute(path: Routes.events, builder: (_, _) => const EventsScreen()),
          GoRoute(
              path: Routes.schedule,
              builder: (_, _) => const ScheduleScreen()),
          GoRoute(path: Routes.giving, builder: (_, _) => const GivingScreen()),
          GoRoute(
              path: Routes.profile, builder: (_, _) => const ProfileScreen()),
          GoRoute(path: Routes.people, builder: (_, _) => const PeopleScreen()),
          GoRoute(
              path: Routes.visitorLeads,
              builder: (_, _) => const VisitorLeadsScreen()),
          GoRoute(
              path: Routes.finance, builder: (_, _) => const FinanceScreen()),
          GoRoute(path: Routes.media, builder: (_, _) => const MediaScreen()),
          GoRoute(
              path: Routes.reports, builder: (_, _) => const ReportsScreen()),
          GoRoute(
              path: Routes.settings,
              builder: (_, _) => const SettingsScreen()),
        ],
      ),
    ],
  );
});

/// Bridges Riverpod auth state changes to GoRouter's refresh mechanism.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}
