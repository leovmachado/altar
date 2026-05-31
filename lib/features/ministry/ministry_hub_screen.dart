import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/core/navigation/routes.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

/// Ministry hub — the user's home for the ministries they serve in.
///
/// Shell screen: no Scaffold/AppBar (the app shell provides them). Returns a
/// scrollable body. Top-to-bottom: a slim "serving next" status strip, a full
/// width link to the complete schedule, then the list of ministries the user
/// belongs to. Mock data only (Phase 1A).
class MinistryHubScreen extends ConsumerWidget {
  const MinistryHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ministries = MockData.ministries;
    final next = MockData.nextAssignment;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ServingNextStrip(assignment: next),
        const SizedBox(height: AppSpacing.lg),
        AltarButton(
          label: context.l10n.ministryFullSchedule,
          icon: Icons.calendar_month_rounded,
          variant: AltarButtonVariant.secondary,
          expand: true,
          onPressed: () => context.push(Routes.fullSchedule),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: context.l10n.ministryHubMyMinistries),
        for (var i = 0; i < ministries.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          _MinistryCard(ministry: ministries[i]),
        ],
      ],
    );

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        if (context.isDesktop)
          ContentBounds(maxWidth: 900, child: content)
        else
          content,
      ],
    );
  }
}

/// Slim, elegant "serving next" status strip — a thin glass band with a subtle
/// brand tint, not a hero card. Tapping it opens the full schedule.
class _ServingNextStrip extends StatelessWidget {
  const _ServingNextStrip({required this.assignment});

  final ScheduleAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;

    final (tone, statusLabel) = switch (assignment.status) {
      ScheduleStatus.confirmed => (BadgeTone.success, context.l10n.scheduleConfirmed),
      ScheduleStatus.pending => (BadgeTone.warning, context.l10n.schedulePending),
      ScheduleStatus.declined => (BadgeTone.danger, context.l10n.scheduleDeclined),
    };

    return GlassCard(
      onTap: () => context.push(Routes.fullSchedule),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.teal.withValues(alpha: 0.14),
          AppColors.aqua.withValues(alpha: 0.06),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: AppRadii.brSm,
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.ministryNextServeTitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: altar.inkSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.ministryServeDetail(
                    assignment.eventTitle,
                    assignment.ministryName ?? '',
                    assignment.role,
                  ),
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusBadge(statusLabel, tone: tone),
        ],
      ),
    );
  }
}

/// A single tappable ministry row — leading brand-tinted icon, name, the user's
/// role + member count, and a trailing chevron. Opens the ministry detail.
class _MinistryCard extends StatelessWidget {
  const _MinistryCard({required this.ministry});

  final Ministry ministry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final role = ministry.role;

    return GlassCard(
      onTap: () => context.push(Routes.ministryDetailFor(ministry.id)),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.teal.withValues(alpha: 0.16),
                  AppColors.aqua.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: AppRadii.brMd,
            ),
            child: Icon(
              ministry.icon,
              size: 24,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ministry.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  role != null && role.isNotEmpty
                      ? '$role · ${context.l10n.ministryMembersCount(ministry.memberCount)}'
                      : context.l10n.ministryMembersCount(ministry.memberCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: altar.inkSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            color: altar.inkTertiary,
          ),
        ],
      ),
    );
  }
}
