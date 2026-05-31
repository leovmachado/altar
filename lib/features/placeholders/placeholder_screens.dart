import 'package:flutter/material.dart';
import '../../core/design_system.dart';
import '../../core/localization/l10n_extension.dart';

/// Modules intentionally deferred past Phase 1A. Each renders the branded
/// "coming soon" placeholder so the navigation shell feels complete during
/// design review without implementing any feature logic.
class _ModulePlaceholder extends StatelessWidget {
  const _ModulePlaceholder({required this.module, required this.icon});
  final String module;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ComingSoonView(
      title: l10n.comingSoonTitle,
      body: l10n.comingSoonBody(module),
      icon: icon,
    );
  }
}

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _ModulePlaceholder(module: context.l10n.navPeople, icon: Icons.people_rounded);
}

class VisitorLeadsScreen extends StatelessWidget {
  const VisitorLeadsScreen({super.key});
  @override
  Widget build(BuildContext context) => _ModulePlaceholder(
      module: context.l10n.navVisitorLeads, icon: Icons.person_add_alt_1_rounded);
}

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});
  @override
  Widget build(BuildContext context) => _ModulePlaceholder(
      module: context.l10n.navFinance, icon: Icons.account_balance_wallet_rounded);
}

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});
  @override
  Widget build(BuildContext context) => _ModulePlaceholder(
      module: context.l10n.navMedia, icon: Icons.play_circle_rounded);
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => _ModulePlaceholder(
      module: context.l10n.navReports, icon: Icons.insights_rounded);
}
