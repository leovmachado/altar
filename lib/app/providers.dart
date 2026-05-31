import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/rbac/app_role.dart';
import '../core/rbac/rbac_service.dart';
import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'auth_controller.dart';

// ---- Repositories (swap these overrides for Supabase impls later) ----------
final eventsRepositoryProvider =
    Provider<EventsRepository>((ref) => const MockEventsRepository());
final scheduleRepositoryProvider =
    Provider<ScheduleRepository>((ref) => const MockScheduleRepository());
final givingRepositoryProvider =
    Provider<GivingRepository>((ref) => const MockGivingRepository());
final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => const MockProfileRepository());

// ---- Current user + RBAC ----------------------------------------------------
final currentUserProvider = Provider<UserProfile?>(
  (ref) => ref.watch(authControllerProvider).user,
);

/// Effective authorization for the signed-in user. Widgets read this to gate
/// UI — they never hardcode role checks.
final rbacProvider = Provider<RbacService>((ref) {
  final user = ref.watch(currentUserProvider);
  return RbacService(user?.roles ?? const [AppRole.member]);
});

final dashboardTypeProvider = Provider<DashboardType>(
  (ref) => ref.watch(rbacProvider).dashboardType,
);

// ---- Locale -----------------------------------------------------------------
/// null => follow system locale.
class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(null);
  void setLocale(Locale? locale) => state = locale;
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale?>((ref) => LocaleController());

// ---- Theme mode -------------------------------------------------------------
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.light); // light is primary
  void toggle() =>
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
        (ref) => ThemeModeController());
