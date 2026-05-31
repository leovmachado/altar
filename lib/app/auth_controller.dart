import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/rbac/app_role.dart';
import '../data/mock/mock_data.dart';
import '../data/models/models.dart';

/// Mock authentication state. NO real auth in Phase 1A — every sign-in method
/// resolves to a mock logged-in user. The shape mirrors what a Supabase-backed
/// `AuthController` will expose later (status + current user).
enum AuthStatus { signedOut, signedIn }

@immutable
class AuthState {
  const AuthState({required this.status, this.user});
  final AuthStatus status;
  final UserProfile? user;

  bool get isSignedIn => status == AuthStatus.signedIn && user != null;

  AuthState copyWith({AuthStatus? status, UserProfile? user}) =>
      AuthState(status: status ?? this.status, user: user ?? this.user);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(_initialState());

  /// Demo bootstrap via `--dart-define` (all default OFF, so normal launches
  /// show the mock sign-in screen). Used to capture deterministic screenshots:
  ///   --dart-define=START_SIGNED_IN=true --dart-define=START_DASHBOARD=lead_pastor
  static AuthState _initialState() {
    const signedIn = bool.fromEnvironment('START_SIGNED_IN');
    if (!signedIn) return const AuthState(status: AuthStatus.signedOut);
    const persona = String.fromEnvironment('START_DASHBOARD', defaultValue: 'volunteer');
    final type = switch (persona) {
      'member' => DashboardType.member,
      'ministry_leader' => DashboardType.ministryLeader,
      'lead_pastor' => DashboardType.leadPastor,
      'financial_leader' => DashboardType.financialLeader,
      _ => DashboardType.volunteer,
    };
    return AuthState(
      status: AuthStatus.signedIn,
      user: MockData.userForDashboard(type),
    );
  }

  /// All sign-in entry points are placeholders that drop the user into the demo.
  void signInWithEmail(String email, String password) => _enterDemo();
  void signInWithGoogle() => _enterDemo();
  void signInWithApple() => _enterDemo();

  void _enterDemo() {
    state = AuthState(status: AuthStatus.signedIn, user: MockData.defaultUser);
  }

  void signOut() {
    state = const AuthState(status: AuthStatus.signedOut);
  }

  /// Demo affordance: preview a different role-tailored experience without
  /// leaving the app. Drives the role-based dashboards for design review.
  void previewDashboard(DashboardType type) {
    state = AuthState(
      status: AuthStatus.signedIn,
      user: MockData.userForDashboard(type),
    );
  }

  /// Demo affordance: swap the current user's roles (RBAC review).
  void setRoles(List<AppRole> roles) {
    final u = state.user;
    if (u == null) return;
    state = state.copyWith(user: u.copyWith(roles: roles));
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) => AuthController());
