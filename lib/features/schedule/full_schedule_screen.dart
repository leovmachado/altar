import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/core/rbac/permissions.dart';
import 'package:altar/app/providers.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

/// Full Schedule — a pushed full-screen surface with two tabs:
///  * List: the user's upcoming assignments, availability and (for leaders)
///    the roster editor.
///  * Calendar: a hand-built month grid that highlights scheduled days on-brand.
///
/// Phase 1A: mock data only. All interactions are visual/local state.
class FullScheduleScreen extends ConsumerStatefulWidget {
  const FullScheduleScreen({super.key, this.initialTab = 0});

  /// 0 = List, 1 = Calendar. Lets the calendar view be deep-linked.
  final int initialTab;

  @override
  ConsumerState<FullScheduleScreen> createState() => _FullScheduleScreenState();
}

class _FullScheduleScreenState extends ConsumerState<FullScheduleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// First day of the currently visible calendar month.
  late DateTime _visibleMonth;

  /// Local-only confirmation toggles for pending assignments (visual demo).
  final Map<String, ScheduleStatus> _statusOverrides = {};

  /// Local-only availability toggles for the weekday chips (visual demo).
  final Set<int> _unavailableDays = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
    // Default the calendar to the month of the soonest assignment so the
    // highlighted days are visible immediately.
    final anchor = MockData.nextAssignment.startsAt;
    _visibleMonth = DateTime(anchor.year, anchor.month);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ScheduleStatus _statusFor(ScheduleAssignment a) =>
      _statusOverrides[a.id] ?? a.status;

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: loc.actionBack,
          onPressed: () => context.pop(),
        ),
        title: Text(loc.fullScheduleTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.scheduleTabList),
            Tab(text: loc.scheduleTabCalendar),
          ],
        ),
      ),
      body: GlowBackground(
        child: SafeArea(
          top: false,
          child: TabBarView(
            controller: _tabController,
            children: [
              _ListTab(
                statusFor: _statusFor,
                onConfirm: (a) => setState(
                    () => _statusOverrides[a.id] = ScheduleStatus.confirmed),
                onDecline: (a) => setState(
                    () => _statusOverrides[a.id] = ScheduleStatus.declined),
                unavailableDays: _unavailableDays,
                onToggleDay: (i) => setState(() {
                  _unavailableDays.contains(i)
                      ? _unavailableDays.remove(i)
                      : _unavailableDays.add(i);
                }),
              ),
              _CalendarTab(
                visibleMonth: _visibleMonth,
                onPrev: () => _shiftMonth(-1),
                onNext: () => _shiftMonth(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LIST TAB
// ---------------------------------------------------------------------------

class _ListTab extends ConsumerWidget {
  const _ListTab({
    required this.statusFor,
    required this.onConfirm,
    required this.onDecline,
    required this.unavailableDays,
    required this.onToggleDay,
  });

  final ScheduleStatus Function(ScheduleAssignment) statusFor;
  final void Function(ScheduleAssignment) onConfirm;
  final void Function(ScheduleAssignment) onDecline;
  final Set<int> unavailableDays;
  final void Function(int) onToggleDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = context.l10n;
    final canManage = ref.watch(rbacProvider).can(AppPermission.manageSchedule);
    final assignments = MockData.assignments;

    return ContentBounds(
      maxWidth: 800,
      padding: AppSpacing.pagePadding,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SectionHeader(
            title: loc.scheduleMyAssignments,
            icon: Icons.event_available_rounded,
          ),
          if (assignments.isEmpty)
            EmptyState(
              title: loc.ministryNoUpcoming,
              message: loc.scheduleAvailablePrompt,
              icon: Icons.event_busy_rounded,
            )
          else
            for (final a in assignments) ...[
              _AssignmentCard(
                assignment: a,
                status: statusFor(a),
                onConfirm: () => onConfirm(a),
                onDecline: () => onDecline(a),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          const SizedBox(height: AppSpacing.md),

          // ---- Availability ------------------------------------------------
          SectionHeader(
            title: loc.scheduleAvailability,
            icon: Icons.event_repeat_rounded,
          ),
          _AvailabilityCard(
            unavailableDays: unavailableDays,
            onToggleDay: onToggleDay,
          ),

          // ---- Leader editor (gated) --------------------------------------
          if (canManage) ...[
            const SizedBox(height: AppSpacing.md),
            SectionHeader(
              title: loc.scheduleLeaderEditor,
              icon: Icons.edit_calendar_rounded,
            ),
            _LeaderEditorCard(),
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
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
    final theme = Theme.of(context);
    final altar = context.altar;
    final loc = context.l10n;
    final localeStr = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.MMMEd(localeStr).format(assignment.startsAt);
    final timeLabel = DateFormat.jm(localeStr).format(assignment.startsAt);
    final ministryName = assignment.ministryName;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  assignment.eventTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              _statusBadge(context, status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (ministryName != null && ministryName.isNotEmpty)
                StatusBadge(
                  ministryName,
                  tone: BadgeTone.brand,
                  icon: Icons.diversity_3_rounded,
                ),
              StatusBadge(
                '${loc.scheduleRoleLabel} · ${assignment.role}',
                icon: Icons.badge_outlined,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaRow(
            icon: Icons.schedule_rounded,
            label: loc.eventsWhen,
            value: '$dateLabel · $timeLabel',
          ),
          const SizedBox(height: AppSpacing.xxs),
          _MetaRow(
            icon: Icons.place_outlined,
            label: loc.eventsLocation,
            value: assignment.location,
          ),
          if (assignment.team.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(
                  loc.scheduleTeam,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: altar.inkSecondary),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: SizedBox(
                    height: 28,
                    child: Stack(
                      children: [
                        for (var i = 0; i < assignment.team.length; i++)
                          Positioned(
                            left: i * 20.0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: AltarAvatar(
                                name: assignment.team[i],
                                radius: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (status == ScheduleStatus.pending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AltarButton(
                    label: loc.scheduleConfirm,
                    icon: Icons.check_rounded,
                    expand: true,
                    onPressed: onConfirm,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AltarButton(
                    label: loc.scheduleDecline,
                    icon: Icons.close_rounded,
                    variant: AltarButtonVariant.secondary,
                    expand: true,
                    onPressed: onDecline,
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

class _MetaRow extends StatelessWidget {
  const _MetaRow({
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: altar.inkTertiary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(color: altar.inkSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({
    required this.unavailableDays,
    required this.onToggleDay,
  });

  final Set<int> unavailableDays;
  final void Function(int) onToggleDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final loc = context.l10n;
    final localeStr = Localizations.localeOf(context).toString();
    // Build localized weekday short labels Mon..Sun.
    final symbols = DateFormat.E(localeStr);
    // 2024-01-01 is a Monday; iterate 7 days for Mon..Sun ordering.
    final monday = DateTime(2024, 1, 1);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.scheduleAvailablePrompt,
            style: theme.textTheme.bodyMedium?.copyWith(color: altar.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var i = 0; i < 7; i++)
                _DayChip(
                  label: symbols.format(monday.add(Duration(days: i))),
                  available: !unavailableDays.contains(i),
                  onTap: () => onToggleDay(i),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              StatusBadge(loc.scheduleAvailable, tone: BadgeTone.success),
              const SizedBox(width: AppSpacing.xs),
              StatusBadge(loc.scheduleUnavailable, tone: BadgeTone.neutral),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.available,
    required this.onTap,
  });

  final String label;
  final bool available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final color = available ? AppColors.teal : altar.inkTertiary;
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.brSm,
      child: InkWell(
        borderRadius: AppRadii.brSm,
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: available ? 0.12 : 0.06),
            borderRadius: AppRadii.brSm,
            border: Border.all(color: color.withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                available ? Icons.check_circle_rounded : Icons.block_rounded,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderEditorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final loc = context.l10n;
    final roster = MockData.rosterDraft;

    return GlassCard(
      glow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.scheduleLeaderEditorSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(color: altar.inkSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final entry in roster.entries) ...[
            _RosterRow(role: entry.key, name: entry.value),
            if (entry.key != roster.keys.last)
              Divider(height: AppSpacing.lg, color: altar.border),
          ],
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AltarButton(
                label: loc.schedulePreviewChanges,
                icon: Icons.visibility_outlined,
                variant: AltarButtonVariant.secondary,
                onPressed: () {},
              ),
              AltarButton(
                label: loc.schedulePublish,
                icon: Icons.send_rounded,
                onPressed: () {},
              ),
              StatusBadge(loc.scheduleDraft, tone: BadgeTone.warning),
            ],
          ),
        ],
      ),
    );
  }
}

class _RosterRow extends StatelessWidget {
  const _RosterRow({required this.role, required this.name});

  final String role;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final loc = context.l10n;
    final filled = name != null;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            role,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: altar.inkSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        if (filled)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                AltarAvatar(name: name!, radius: 12),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    name!,
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        else
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(
                loc.scheduleUnassigned,
                tone: BadgeTone.warning,
                icon: Icons.person_add_alt_1_outlined,
              ),
            ),
          ),
      ],
    );
  }
}

Widget _statusBadge(BuildContext context, ScheduleStatus status) {
  final loc = context.l10n;
  return switch (status) {
    ScheduleStatus.confirmed => StatusBadge(
        loc.scheduleConfirmed,
        tone: BadgeTone.success,
        icon: Icons.check_circle_rounded,
      ),
    ScheduleStatus.pending => StatusBadge(
        loc.schedulePending,
        tone: BadgeTone.warning,
        icon: Icons.hourglass_top_rounded,
      ),
    ScheduleStatus.declined => StatusBadge(
        loc.scheduleDeclined,
        tone: BadgeTone.danger,
        icon: Icons.cancel_rounded,
      ),
  };
}

// ---------------------------------------------------------------------------
// CALENDAR TAB
// ---------------------------------------------------------------------------

class _CalendarTab extends StatelessWidget {
  const _CalendarTab({
    required this.visibleMonth,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime visibleMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final loc = context.l10n;
    final localeStr = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final altar = context.altar;

    // Scheduled day-date keys (non-declined assignments only).
    final scheduledDays = <DateTime>{
      for (final a in MockData.assignments)
        if (a.status != ScheduleStatus.declined)
          DateTime(a.startsAt.year, a.startsAt.month, a.startsAt.day),
    };

    final today = MockData.now;
    final todayKey = DateTime(today.year, today.month, today.day);

    // Assignments that fall in the visible month, for the connected list below.
    final monthAssignments = MockData.assignments
        .where((a) =>
            a.startsAt.year == visibleMonth.year &&
            a.startsAt.month == visibleMonth.month &&
            a.status != ScheduleStatus.declined)
        .toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    return ContentBounds(
      maxWidth: 800,
      padding: AppSpacing.pagePadding,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GlassCard(
            child: Column(
              children: [
                // Month header with prev/next chevrons.
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: onPrev,
                    ),
                    Expanded(
                      child: Text(
                        DateFormat.yMMMM(localeStr).format(visibleMonth),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: onNext,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                _WeekdayHeader(localeStr: localeStr),
                const SizedBox(height: AppSpacing.xs),
                _MonthGrid(
                  visibleMonth: visibleMonth,
                  scheduledDays: scheduledDays,
                  todayKey: todayKey,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Legend.
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: AppColors.brandGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: AppShadows.glow(altar.glowColor, strength: 0.4),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                loc.scheduleScheduledLegend,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: altar.inkSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Connected list of this month's scheduled assignments.
          SectionHeader(
            title: loc.labelUpcoming,
            icon: Icons.event_note_rounded,
          ),
          if (monthAssignments.isEmpty)
            EmptyState(
              title: loc.ministryNoUpcoming,
              message: loc.scheduleScheduledLegend,
              icon: Icons.event_busy_rounded,
            )
          else
            for (final a in monthAssignments) ...[
              _CompactAssignmentRow(assignment: a),
              const SizedBox(height: AppSpacing.xs),
            ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.localeStr});

  final String localeStr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final symbols = DateFormat.E(localeStr);
    final monday = DateTime(2024, 1, 1); // a Monday
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Center(
              child: Text(
                symbols.format(monday.add(Duration(days: i))),
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: altar.inkTertiary),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.visibleMonth,
    required this.scheduledDays,
    required this.todayKey,
  });

  final DateTime visibleMonth;
  final Set<DateTime> scheduledDays;
  final DateTime todayKey;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    // DateTime.weekday: Mon=1..Sun=7 -> leading blanks for Monday-start grid.
    final leadingBlanks = firstOfMonth.weekday - 1;
    final daysInMonth =
        DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        for (var row = 0; row < rows; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(
                  child: _buildCell(context, row * 7 + col - leadingBlanks + 1),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildCell(BuildContext context, int dayNum) {
    if (dayNum < 1 ||
        dayNum > DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day) {
      return const AspectRatio(aspectRatio: 1, child: SizedBox.shrink());
    }
    final date = DateTime(visibleMonth.year, visibleMonth.month, dayNum);
    final isScheduled = scheduledDays.contains(date);
    final isToday = date == todayKey;
    return _DayCell(
      dayNum: dayNum,
      isScheduled: isScheduled,
      isToday: isToday,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.dayNum,
    required this.isScheduled,
    required this.isToday,
  });

  final int dayNum;
  final bool isScheduled;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;

    final TextStyle textStyle = isScheduled
        ? theme.textTheme.titleSmall!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          )
        : theme.textTheme.bodyMedium!;

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxs),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: isScheduled
                ? const LinearGradient(
                    colors: AppColors.brandGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: AppRadii.brSm,
            border: isToday && !isScheduled
                ? Border.all(color: AppColors.teal, width: 1.6)
                : (isToday
                    ? Border.all(color: Colors.white.withValues(alpha: 0.85), width: 1.6)
                    : null),
            boxShadow: isScheduled
                ? AppShadows.glow(altar.glowColor, strength: 0.5)
                : null,
          ),
          child: Center(
            child: Text('$dayNum', style: textStyle),
          ),
        ),
      ),
    );
  }
}

class _CompactAssignmentRow extends StatelessWidget {
  const _CompactAssignmentRow({required this.assignment});

  final ScheduleAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final localeStr = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.MMMEd(localeStr).format(assignment.startsAt);
    final timeLabel = DateFormat.jm(localeStr).format(assignment.startsAt);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.12),
              borderRadius: AppRadii.brSm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.MMM(localeStr).format(assignment.startsAt),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: AppColors.tealDeep),
                ),
                Text(
                  DateFormat.d(localeStr).format(assignment.startsAt),
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: AppColors.tealDeep),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.eventTitle,
                  style: theme.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateLabel · $timeLabel · ${assignment.role}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: altar.inkSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          _statusBadge(context, assignment.status),
        ],
      ),
    );
  }
}
