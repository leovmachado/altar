import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/core/navigation/routes.dart';
import 'package:altar/core/rbac/app_role.dart';
import 'package:altar/app/providers.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

/// Desktop operator cockpit. Role-tailored dashboard that renders one of five
/// distinct layouts based on [dashboardTypeProvider]. Shell screen: no
/// Scaffold/AppBar, returns a scrollable body.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(dashboardTypeProvider);
    final user = ref.watch(currentUserProvider) ?? MockData.defaultUser;

    final Widget body = switch (type) {
      DashboardType.member => _MemberDash(user: user),
      DashboardType.volunteer => _VolunteerDash(user: user),
      DashboardType.ministryLeader => _MinistryLeaderDash(user: user),
      DashboardType.leadPastor => _LeadPastorDash(user: user),
      DashboardType.financialLeader => _FinancialLeaderDash(user: user),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ContentBounds(
        maxWidth: 1180,
        child: body,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared building blocks
// ---------------------------------------------------------------------------

class _Welcome extends StatelessWidget {
  const _Welcome({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashWelcome(user.firstName),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Responsive grid of stat tiles. ~4 per row on desktop, 2 on mobile.
class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.cards});
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = context.isMobile
            ? 2
            : (constraints.maxWidth > 900 ? 4 : 3);
        const gap = AppSpacing.md;
        final tileWidth =
            (constraints.maxWidth - gap * (perRow - 1)) / perRow;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in cards)
              SizedBox(width: tileWidth, child: card),
          ],
        );
      },
    );
  }
}

/// Two cards side by side on desktop, stacked on mobile.
class _SplitRow extends StatelessWidget {
  const _SplitRow({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        children: [
          left,
          const SizedBox(height: AppSpacing.md),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: right),
      ],
    );
  }
}

/// Simple bar chart card driven by MockData.givingTrend.
class _GivingTrendCard extends StatelessWidget {
  const _GivingTrendCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trend = MockData.givingTrend;
    const maxHeight = 120.0;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashGivingTrend,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: maxHeight + 28,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final point in trend)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxs,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: point.value.clamp(0.0, 1.0) * maxHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: context.altar.brandGradient,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(AppRadii.sm),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            point.month,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: context.altar.inkTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Recent activity feed card.
class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = MockData.recentActivity;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.dashRecentActivity,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: context.altar.brandGradient,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      item.text,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    item.time,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.altar.inkTertiary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

String _formatCents(int cents) =>
    NumberFormat.currency(symbol: r'$', decimalDigits: 0).format(cents / 100);

BadgeTone _toneFor(ScheduleStatus status) => switch (status) {
      ScheduleStatus.confirmed => BadgeTone.success,
      ScheduleStatus.pending => BadgeTone.warning,
      ScheduleStatus.declined => BadgeTone.danger,
    };

String _statusLabel(BuildContext context, ScheduleStatus status) =>
    switch (status) {
      ScheduleStatus.confirmed => context.l10n.scheduleConfirmed,
      ScheduleStatus.pending => context.l10n.schedulePending,
      ScheduleStatus.declined => context.l10n.scheduleDeclined,
    };

// ---------------------------------------------------------------------------
// Lead Pastor
// ---------------------------------------------------------------------------

class _LeadPastorDash extends StatelessWidget {
  const _LeadPastorDash({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Welcome(user: user),
        _StatGrid(
          cards: [
            StatCard(
              label: context.l10n.dashMembers,
              value: '${MockData.orgMembers}',
              icon: Icons.groups_outlined,
            ),
            StatCard(
              label: context.l10n.dashNewVisitors,
              value: '${MockData.orgNewVisitors}',
              icon: Icons.waving_hand_outlined,
            ),
            StatCard(
              label: context.l10n.dashGivingMonth,
              value: MockData.orgGivingMonth,
              delta: MockData.orgGivingDelta,
              icon: Icons.volunteer_activism_outlined,
            ),
            StatCard(
              label: context.l10n.dashAttendance,
              value: '${MockData.orgAttendance}',
              delta: MockData.orgAttendanceDelta,
              icon: Icons.event_seat_outlined,
            ),
            StatCard(
              label: context.l10n.dashVolunteersScheduled,
              value: '${MockData.orgVolunteersScheduled}',
              icon: Icons.diversity_3_outlined,
            ),
            StatCard(
              label: context.l10n.dashUpcomingEvents,
              value: '${MockData.orgUpcomingEvents}',
              icon: Icons.calendar_month_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SplitRow(
          left: _GivingTrendCard(),
          right: _RecentActivityCard(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Financial Leader
// ---------------------------------------------------------------------------

class _FinancialLeaderDash extends StatelessWidget {
  const _FinancialLeaderDash({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Welcome(user: user),
        _StatGrid(
          cards: [
            StatCard(
              label: context.l10n.dashGivingMonth,
              value: MockData.orgGivingMonth,
              delta: MockData.orgGivingDelta,
              icon: Icons.volunteer_activism_outlined,
            ),
            StatCard(
              label: context.l10n.dashBudgetUsed,
              value: MockData.orgBudgetUsed,
              icon: Icons.pie_chart_outline,
            ),
            StatCard(
              label: context.l10n.dashPledges,
              value: MockData.orgPledges,
              icon: Icons.handshake_outlined,
            ),
            StatCard(
              label: context.l10n.givingYearToDate,
              value: _formatCents(MockData.givingYearToDateCents),
              icon: Icons.calendar_today_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _SplitRow(
          left: const _GivingTrendCard(),
          right: GlassCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      color: context.altar.glowColor,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      context.l10n.navFinance,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.givingSecure,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.altar.inkSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AltarButton(
                  label: context.l10n.navFinance,
                  icon: Icons.arrow_forward,
                  variant: AltarButtonVariant.secondary,
                  expand: true,
                  onPressed: () => context.go(Routes.finance),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Ministry Leader
// ---------------------------------------------------------------------------

class _MinistryLeaderDash extends StatelessWidget {
  const _MinistryLeaderDash({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assignments = MockData.assignments;
    final servingCount = assignments
        .where((a) => a.status != ScheduleStatus.declined)
        .length;
    final openRoles =
        MockData.rosterDraft.values.where((v) => v == null).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Welcome(user: user),
        _StatGrid(
          cards: [
            StatCard(
              label: context.l10n.dashMyTeam,
              value: '12',
              icon: Icons.diversity_3_outlined,
            ),
            StatCard(
              label: context.l10n.dashServingThisWeek,
              value: '$servingCount',
              icon: Icons.event_available_outlined,
            ),
            StatCard(
              label: context.l10n.dashOpenRoles,
              value: '$openRoles',
              icon: Icons.person_search_outlined,
            ),
            StatCard(
              label: context.l10n.dashUpcomingEvents,
              value: '${MockData.orgUpcomingEvents}',
              icon: Icons.calendar_month_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: context.l10n.dashServingThisWeek,
                icon: Icons.calendar_view_week_outlined,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final a in assignments)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.role,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              '${a.eventTitle} · '
                              '${DateFormat.MMMEd(Localizations.localeOf(context).toString()).format(a.startsAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.altar.inkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      StatusBadge(
                        _statusLabel(context, a.status),
                        tone: _toneFor(a.status),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              AltarButton(
                label: context.l10n.scheduleLeaderEditor,
                icon: Icons.edit_calendar_outlined,
                onPressed: () => context.go(Routes.schedule),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Volunteer
// ---------------------------------------------------------------------------

class _VolunteerDash extends StatelessWidget {
  const _VolunteerDash({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final next = MockData.nextAssignment;
    final servingCount = MockData.assignments
        .where((a) => a.status != ScheduleStatus.declined)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Welcome(user: user),
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          glow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.scheduleNextServe,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  StatusBadge(
                    _statusLabel(context, next.status),
                    tone: _toneFor(next.status),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                next.role,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                next.eventTitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.altar.inkSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 18,
                    color: context.altar.inkTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${DateFormat.MMMEd(loc).format(next.startsAt)} · '
                    '${DateFormat.jm(loc).format(next.startsAt)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.altar.inkSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 18,
                    color: context.altar.inkTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    next.location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.altar.inkSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AltarButton(
                label: context.l10n.scheduleTitle,
                icon: Icons.calendar_today_outlined,
                expand: true,
                onPressed: () => context.go(Routes.schedule),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _StatGrid(
          cards: [
            StatCard(
              label: context.l10n.dashServingThisWeek,
              value: '$servingCount',
              icon: Icons.event_available_outlined,
            ),
            StatCard(
              label: context.l10n.dashGivingMonth,
              value: _formatCents(user.givenThisMonthCents),
              icon: Icons.volunteer_activism_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AltarButton(
          label: context.l10n.givingTitle,
          icon: Icons.favorite_outline,
          variant: AltarButtonVariant.secondary,
          onPressed: () => context.go(Routes.giving),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Member
// ---------------------------------------------------------------------------

class _MemberDash extends StatelessWidget {
  const _MemberDash({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Welcome(user: user),
        _StatGrid(
          cards: [
            StatCard(
              label: context.l10n.givingThisMonth,
              value: _formatCents(user.givenThisMonthCents),
              icon: Icons.volunteer_activism_outlined,
            ),
            StatCard(
              label: context.l10n.dashUpcomingEvents,
              value: '${MockData.events.length}',
              icon: Icons.calendar_month_outlined,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _SplitRow(
          left: GlassCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            onTap: () => context.go(Routes.events),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.celebration_outlined,
                  color: context.altar.glowColor,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.eventsUpcoming,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  context.l10n.homeQuickEvents,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.altar.inkSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AltarButton(
                  label: context.l10n.actionViewAll,
                  icon: Icons.arrow_forward,
                  variant: AltarButtonVariant.ghost,
                  onPressed: () => context.go(Routes.events),
                ),
              ],
            ),
          ),
          right: GlassCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            onTap: () => context.go(Routes.giving),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.favorite_outline,
                  color: context.altar.glowColor,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.homeGivingCardTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  context.l10n.homeGivingCardSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.altar.inkSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AltarButton(
                  label: context.l10n.givingGiveNow,
                  icon: Icons.arrow_forward,
                  onPressed: () => context.go(Routes.giving),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
