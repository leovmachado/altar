import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

/// Full-screen, pushed ministry detail page. Owns its own Scaffold.
class MinistryDetailScreen extends ConsumerWidget {
  const MinistryDetailScreen({super.key, required this.ministryId});

  final String ministryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = MockData.ministryById(ministryId);
    final upcoming = MockData.assignmentsForMinistry(ministryId);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: context.l10n.actionBack,
          onPressed: () => context.pop(),
        ),
        title: Text(m.name),
      ),
      body: GlowBackground(
        child: ContentBounds(
          maxWidth: 760,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xxl,
            ),
            children: [
              _MinistryHeaderCard(ministry: m),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: context.l10n.ministryAbout),
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  m.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.5),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: context.l10n.ministryUpcoming),
              if (upcoming.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: EmptyState(
                    title: context.l10n.ministryNoUpcoming,
                    message: context.l10n.ministryNoUpcoming,
                    icon: Icons.event_busy_rounded,
                  ),
                )
              else
                for (var i = 0; i < upcoming.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.sm),
                  _AssignmentCard(assignment: upcoming[i]),
                ],
              const SizedBox(height: AppSpacing.lg),
              SectionHeader(title: context.l10n.ministryResources),
              const _ResourcesCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MinistryHeaderCard extends StatelessWidget {
  const _MinistryHeaderCard({required this.ministry});

  final Ministry ministry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final role = ministry.role ?? '';

    return GlassCard(
      glow: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: AppRadii.brLg,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.brandGradient,
                  ),
                  boxShadow: AppShadows.glow(altar.glowColor, strength: 0.35),
                ),
                child: Icon(
                  ministry.icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ministry.name,
                      style: theme.textTheme.headlineSmall,
                    ),
                    if (role.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        context.l10n.ministryYourRole,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: altar.inkTertiary),
                      ),
                      const SizedBox(height: 4),
                      // Align keeps the badge at its intrinsic width (left)
                      // so its label can't be forced to overflow the column.
                      Align(
                        alignment: Alignment.centerLeft,
                        child: StatusBadge(
                          role,
                          tone: BadgeTone.brand,
                          icon: Icons.verified_rounded,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _HeaderStat(
                    icon: Icons.shield_moon_rounded,
                    label: context.l10n.ministryLeader,
                    value: ministry.leaderName,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _HeaderStat(
                    icon: Icons.groups_rounded,
                    label: context.l10n.ministryMembersCount(
                      ministry.memberCount,
                    ),
                    value: '${ministry.memberCount}',
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

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: altar.surfaceMuted,
        borderRadius: AppRadii.brMd,
        border: Border.all(color: altar.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.teal),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: altar.inkTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({required this.assignment});

  final ScheduleAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final loc = Localizations.localeOf(context).toString();

    final dateText =
        '${DateFormat.MMMEd(loc).format(assignment.startsAt)} · '
        '${DateFormat.jm(loc).format(assignment.startsAt)}';

    final (label, tone) = switch (assignment.status) {
      ScheduleStatus.confirmed => (
          context.l10n.scheduleConfirmed,
          BadgeTone.success,
        ),
      ScheduleStatus.pending => (
          context.l10n.schedulePending,
          BadgeTone.warning,
        ),
      ScheduleStatus.declined => (
          context.l10n.scheduleDeclined,
          BadgeTone.danger,
        ),
    };

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  assignment.eventTitle,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge(label, tone: tone),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${context.l10n.scheduleRoleLabel} · ${assignment.role}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: altar.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(icon: Icons.event_rounded, text: dateText),
          const SizedBox(height: AppSpacing.xs),
          _MetaRow(
            icon: Icons.place_rounded,
            text: assignment.location,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;

    return Row(
      children: [
        Icon(icon, size: 16, color: altar.inkTertiary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: altar.inkSecondary),
          ),
        ),
      ],
    );
  }
}

class _ResourcesCard extends StatelessWidget {
  const _ResourcesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.ministryResourcesBody,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: altar.inkSecondary, height: 1.5),
          ),
          const SizedBox(height: AppSpacing.md),
          _ResourceRow(
            icon: Icons.chat_bubble_outline_rounded,
            label: context.l10n.scheduleTeam,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ResourceRow(
            icon: Icons.school_outlined,
            label: context.l10n.ministryAbout,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ResourceRow(
            icon: Icons.folder_outlined,
            label: context.l10n.ministryResources,
          ),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;

    return Opacity(
      opacity: 0.55,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: altar.surfaceMuted,
          borderRadius: AppRadii.brMd,
          border: Border.all(color: altar.glassBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: altar.inkSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Icon(
              Icons.lock_outline_rounded,
              size: 16,
              color: altar.inkTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
