import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/core/navigation/routes.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

/// Events list screen — premium, glassy, responsive grid of church events.
///
/// Shell screen: returns a scrollable body (no Scaffold / AppBar).
class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

enum _EventsTab { upcoming, past }

class _EventsScreenState extends ConsumerState<EventsScreen> {
  _EventsTab _tab = _EventsTab.upcoming;

  List<ChurchEvent> get _events {
    final all = MockData.events;
    // Phase 1A mock: split the same source into two plausible buckets.
    switch (_tab) {
      case _EventsTab.upcoming:
        final upcoming =
            all.where((e) => e.startsAt.isAfter(MockData.now)).toList();
        return upcoming.isEmpty ? all : upcoming;
      case _EventsTab.past:
        final past =
            all.where((e) => e.startsAt.isBefore(MockData.now)).toList();
        return past.isEmpty ? all : past;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final events = _events;

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        ContentBounds(
          maxWidth: 1100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EventsTabBar(
                current: _tab,
                onChanged: (t) => setState(() => _tab = t),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (events.isEmpty)
                EmptyState(
                  title: l10n.eventsTitle,
                  message: l10n.eventsPast,
                  icon: Icons.event_busy_outlined,
                )
              else
                _EventsGrid(
                  events: events,
                  dimmed: _tab == _EventsTab.past,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventsTabBar extends StatelessWidget {
  const _EventsTabBar({required this.current, required this.onChanged});

  final _EventsTab current;
  final ValueChanged<_EventsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      borderRadius: AppRadii.brXl,
      child: Row(
        children: [
          _EventsTabPill(
            label: l10n.eventsUpcoming,
            selected: current == _EventsTab.upcoming,
            onTap: () => onChanged(_EventsTab.upcoming),
          ),
          _EventsTabPill(
            label: l10n.eventsPast,
            selected: current == _EventsTab.past,
            onTap: () => onChanged(_EventsTab.past),
          ),
        ],
      ),
    );
  }
}

class _EventsTabPill extends StatelessWidget {
  const _EventsTabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final altar = context.altar;
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: AppRadii.brXl,
            gradient:
                selected ? LinearGradient(colors: altar.brandGradient) : null,
            boxShadow: selected
                ? AppShadows.glow(altar.glowColor, strength: 0.6)
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected ? Colors.white : altar.inkSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _EventsGrid extends StatelessWidget {
  const _EventsGrid({required this.events, required this.dimmed});

  final List<ChurchEvent> events;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context) => Column(
        children: [
          for (final e in events) ...[
            _EventCard(event: e, dimmed: dimmed),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
      desktop: (context) => Wrap(
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        children: [
          for (final e in events)
            _DesktopGridItem(
              child: _EventCard(event: e, dimmed: dimmed),
            ),
        ],
      ),
    );
  }
}

class _DesktopGridItem extends StatelessWidget {
  const _DesktopGridItem({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Two columns, accounting for the run spacing between them.
        final width = (constraints.maxWidth - AppSpacing.lg) / 2;
        return SizedBox(width: width, child: child);
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.dimmed});

  final ChurchEvent event;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final altar = context.altar;
    final l10n = context.l10n;
    final loc = Localizations.localeOf(context).toString();

    final dateLabel =
        '${DateFormat.MMMEd(loc).format(event.startsAt)} · ${DateFormat.jm(loc).format(event.startsAt)}';

    final card = GlassCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(Routes.eventDetailFor(event.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EventPoster(event: event),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  event.summary,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: altar.inkSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                _EventMetaRow(
                  icon: Icons.calendar_today_outlined,
                  text: dateLabel,
                ),
                const SizedBox(height: AppSpacing.xs),
                _EventMetaRow(
                  icon: Icons.place_outlined,
                  text: event.location,
                ),
                const SizedBox(height: AppSpacing.md),
                Divider(color: altar.border, height: 1),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.eventsAttendees(event.attendeeCount),
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: altar.inkSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (event.isRegistered)
                      StatusBadge(
                        l10n.eventsRegistered,
                        tone: BadgeTone.success,
                        icon: Icons.check_circle_outline,
                      )
                    else
                      AltarButton(
                        label: l10n.eventsRegister,
                        variant: AltarButtonVariant.secondary,
                        icon: Icons.add,
                        onPressed: () =>
                            context.push(Routes.eventDetailFor(event.id)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!dimmed) return card;
    return Opacity(opacity: 0.72, child: card);
  }
}

class _EventMetaRow extends StatelessWidget {
  const _EventMetaRow({required this.icon, required this.text});

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
            style:
                theme.textTheme.bodySmall?.copyWith(color: altar.inkSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EventPoster extends StatelessWidget {
  const _EventPoster({required this.event});

  final ChurchEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = event.posterColors.isNotEmpty
        ? event.posterColors
        : AppColors.brandGradient;

    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Category badge uses the host ministry (a data value, allowed).
            Positioned(
              left: AppSpacing.sm,
              top: AppSpacing.sm,
              child: StatusBadge(
                event.hostMinistry,
                tone: BadgeTone.brand,
              ),
            ),
            if (event.isSpecial)
              Positioned(
                right: AppSpacing.sm,
                top: AppSpacing.sm,
                child: StatusBadge(
                  l10n.eventsTitle,
                  tone: BadgeTone.warning,
                  icon: Icons.star_rounded,
                ),
              ),
            Positioned(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
