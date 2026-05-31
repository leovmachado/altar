import 'app_role.dart';
import 'permissions.dart';

/// Pure, side-effect-free authorization logic. Built from a user's roles and
/// queried by UI/navigation. This is the single source of truth for "can the
/// current user do X" — widgets must call through here, never inline checks.
class RbacService {
  RbacService(this.roles)
      : _permissions = roles
            .expand((r) => kRolePermissions[r] ?? const <AppPermission>{})
            .toSet();

  final List<AppRole> roles;
  final Set<AppPermission> _permissions;

  bool can(AppPermission permission) => _permissions.contains(permission);

  bool canAny(Iterable<AppPermission> permissions) =>
      permissions.any(_permissions.contains);

  bool hasRole(AppRole role) => roles.contains(role);

  Set<AppPermission> get permissions => Set.unmodifiable(_permissions);

  /// Highest-ranked role the user holds; drives default landing experience.
  AppRole get primaryRole {
    if (roles.isEmpty) return AppRole.member;
    return roles.reduce((a, b) => a.rank >= b.rank ? a : b);
  }

  /// Which tailored dashboard to render on Home / desktop Dashboard.
  DashboardType get dashboardType {
    if (can(AppPermission.manageOrganization) ||
        hasRole(AppRole.leadPastor) ||
        hasRole(AppRole.admin)) {
      return DashboardType.leadPastor;
    }
    if (can(AppPermission.manageFinance)) return DashboardType.financialLeader;
    if (can(AppPermission.manageSchedule)) return DashboardType.ministryLeader;
    if (can(AppPermission.serve)) return DashboardType.volunteer;
    return DashboardType.member;
  }
}
