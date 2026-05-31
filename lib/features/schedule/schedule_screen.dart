import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/core/rbac/permissions.dart';
import 'package:altar/app/providers.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  // Local visual overrides for pending assignments (mock only).
  final Map<String, ScheduleStatus> _statusOverrides = {};

  // Local availability toggles keyed by weekday index 1..7 (mock only).
  final Set<int> _availableDays = {1, 3, 5};

  @override
  Widget build(BuildContext context) {
    final rbac = ref.watch(rbacProvider);
    final l10n = context.l10n;
    final loc = Localizations.localeOf(context).toString();
    final canManage = rbac.can(AppPermission.manageSchedule);

    final children = <Widget>[
      SectionHeader(title: l10n.scheduleMyAssignments),
      const SizedBox(height: AppSpacing.sm),
      ...MockData.assignments.map(
        (a) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _AssignmentCard(
            assignment: a,
            status: _statusOverrides[a.id] ?? a.status,
            onConfirm: () => setState(
              () => _statusOverrides[a.id] = ScheduleStatus.confirmed,
            ),
            onDecline: () => setState(
              () => _statusOverrides[a.id] = ScheduleStatus.declined,
            ),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.lg),
      SectionHeader(title: l10n.scheduleAvailability),
      const SizedBox(height: AppSpacing.sm),
      _AvailabilityCard(
        availableDays: _availableDays,
        loc: loc,
        onToggle: (day) => setState(() {
          if (_availableDays.contains(day)) {
            _availableDays.remove(day);
          } else {
            _availableDays.add(day);
          }
        }),
      ),
    ];

    if (canManage) {
      children.addAll([
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(title: l10n.scheduleLeaderEditor),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.scheduleLeaderEditorSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.altar.inkSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        const _RosterEditorCard(),
      ]);
    }

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        ContentBounds(
          maxWidth: 1100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}

({BadgeTone tone, String label}) _statusMeta(
  BuildContext context,
  ScheduleStatus status,
) {
  final l10n = context.l10n;
  switch (status) {
    case ScheduleStatus.confirmed:
      return (tone: BadgeTone.success, label: l10n.scheduleConfirmed);
    case ScheduleStatus.pending:
      return (tone: BadgeTone.warning, label: l10n.schedulePending);
    case ScheduleStatus.declined:
      return (tone: BadgeTone.danger, label: l10n.scheduleDeclined);
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.assignment,
    required this.status,
    required this.onConfirm,
    required this.onDecline,
  });

  final ScheduleAssignment assignment;
  final ScheduleStatus status;
  final VoidCallback onConfirm;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final meta = _statusMeta(context, status);
    final dateLabel = DateFormat.MMMEd(loc).format(assignment.startsAt);
    final timeLabel = DateFormat.jm(loc).format(assignment.startsAt);

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
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge(meta.label, tone: meta.tone),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaLine(
            icon: Icons.work_outline,
            text: '${l10n.scheduleRoleLabel}: ${assignment.role}',
          ),
          const SizedBox(height: AppSpacing.xxs),
          _MetaLine(
            icon: Icons.calendar_today_outlined,
            text: '$dateLabel · $timeLabel',
          ),
          const SizedBox(height: AppSpacing.xxs),
          _MetaLine(
            icon: Icons.place_outlined,
            text: assignment.location,
          ),
          if (assignment.team.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.scheduleTeam,
              style: theme.textTheme.labelMedium?.copyWith(
                color: context.altar.inkSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final name in assignment.team)
                  AltarAvatar(name: name, radius: 16),
              ],
            ),
          ],
          if (status == ScheduleStatus.pending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AltarButton(
                    label: l10n.scheduleConfirm,
                    onPressed: onConfirm,
                    icon: Icons.check,
                    expand: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AltarButton(
                    label: l10n.scheduleDecline,
                    variant: AltarButtonVariant.secondary,
                    onPressed: onDecline,
                    icon: Icons.close,
                    expand: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.altar.inkTertiary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.altar.inkSecondary,
                ),
          ),
        ),
      ],
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({
    required this.availableDays,
    required this.loc,
    required this.onToggle,
  });

  final Set<int> availableDays;
  final String loc;
  final void Function(int weekday) onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    // Build localized short weekday labels for Mon..Sun (DateTime.monday == 1).
    final base = DateTime(2024, 1, 1); // a Monday
    final dayLabels = <int, String>{
      for (var i = 0; i < 7; i++)
        i + 1: DateFormat.E(loc).format(base.add(Duration(days: i))),
    };

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.scheduleAvailablePrompt,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var day = 1; day <= 7; day++)
                FilterChip(
                  label: Text(dayLabels[day] ?? ''),
                  selected: availableDays.contains(day),
                  onSelected: (_) => onToggle(day),
                  tooltip: availableDays.contains(day)
                      ? l10n.scheduleAvailable
                      : l10n.scheduleUnavailable,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RosterEditorCard extends StatelessWidget {
  const _RosterEditorCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final roster = MockData.rosterDraft;
    final entries = roster.entries.toList();

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _RosterRow(role: entries[i].key, volunteer: entries[i].value),
            if (i != entries.length - 1)
              Divider(
                height: AppSpacing.lg,
                color: context.altar.border,
              ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              StatusBadge(l10n.scheduleDraft, tone: BadgeTone.warning),
              const Spacer(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AltarButton(
                  label: l10n.schedulePreviewChanges,
                  variant: AltarButtonVariant.secondary,
                  onPressed: () => _showPreview(context, roster),
                  icon: Icons.visibility_outlined,
                  expand: true,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AltarButton(
                  label: l10n.schedulePublish,
                  onPressed: () {},
                  icon: Icons.publish_outlined,
                  expand: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPreview(BuildContext context, Map<String, String?> roster) {
    final l10n = context.l10n;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.schedulePreviewChanges,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.md),
                for (final e in roster.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.key,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: sheetContext.altar.inkSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        if (e.value != null)
                          StatusBadge(e.value!, tone: BadgeTone.success)
                        else
                          StatusBadge(
                            l10n.scheduleUnassigned,
                            tone: BadgeTone.warning,
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                AltarButton(
                  label: l10n.schedulePublish,
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  icon: Icons.publish_outlined,
                  expand: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RosterRow extends StatelessWidget {
  const _RosterRow({required this.role, required this.volunteer});

  final String role;
  final String? volunteer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final filled = volunteer != null;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.altar.inkSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              if (filled)
                Text(
                  volunteer!,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                )
              else
                Text(
                  l10n.scheduleUnassigned,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.altar.inkTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        if (filled)
          AltarAvatar(name: volunteer!, radius: 18)
        else
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.altar.border,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.add,
              size: 18,
              color: context.altar.inkTertiary,
            ),
          ),
      ],
    );
  }
}
