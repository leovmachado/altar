import '../../l10n/app_localizations.dart';

/// All roles a user can hold. A user may have multiple roles simultaneously.
/// `id` is the stable snake_case identifier that will map to Supabase rows.
enum AppRole {
  superAdmin('super_admin', 100),
  leadPastor('lead_pastor', 90),
  admin('admin', 80),
  financialLeader('financial_leader', 70),
  treasurer('treasurer', 65),
  mediaLeader('media_leader', 60),
  ministryLeader('ministry_leader', 50),
  volunteer('volunteer', 30),
  member('member', 20),
  visitor('visitor', 10);

  const AppRole(this.id, this.rank);

  /// Stable identifier used by the backend.
  final String id;

  /// Higher rank wins when choosing a primary role / default dashboard.
  final int rank;

  static AppRole fromId(String id) =>
      AppRole.values.firstWhere((r) => r.id == id, orElse: () => AppRole.member);

  /// Localized, human-readable label.
  String label(AppLocalizations l10n) => switch (this) {
        AppRole.superAdmin => l10n.roleSuperAdmin,
        AppRole.leadPastor => l10n.roleLeadPastor,
        AppRole.admin => l10n.roleAdmin,
        AppRole.financialLeader => l10n.roleFinancialLeader,
        AppRole.treasurer => l10n.roleTreasurer,
        AppRole.mediaLeader => l10n.roleMediaLeader,
        AppRole.ministryLeader => l10n.roleMinistryLeader,
        AppRole.volunteer => l10n.roleVolunteer,
        AppRole.member => l10n.roleMember,
        AppRole.visitor => l10n.roleVisitor,
      };
}

/// The role-tailored dashboard experience to render.
enum DashboardType { member, volunteer, ministryLeader, leadPastor, financialLeader }
