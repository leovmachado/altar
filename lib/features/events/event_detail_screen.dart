import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

/// Full-screen, pushed event detail page. Owns its own Scaffold.
class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = MockData.eventById(eventId);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlowBackground(
        child: CustomScrollView(
          slivers: [
            _EventPosterAppBar(event: event),
            SliverToBoxAdapter(
              child: ContentBounds(
                maxWidth: 760,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.xxl,
                  ),
                  child: _EventBody(event: event),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _EventActionBar(event: event),
    );
  }
}

class _EventPosterAppBar extends StatelessWidget {
  const _EventPosterAppBar({required this.event});

  final ChurchEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = event.posterColors.isNotEmpty
        ? event.posterColors
        : AppColors.brandGradient;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.sm),
        child: _CircleIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: _CircleIconButton(
            icon: Icons.ios_share_rounded,
            tooltip: l10n.actionShare,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.actionShare)),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _PosterBackground(event: event, colors: colors),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}

class _PosterBackground extends StatelessWidget {
  const _PosterBackground({required this.event, required this.colors});

  final ChurchEvent event;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadii.xl),
          bottomRight: Radius.circular(AppRadii.xl),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppRadii.xl),
                bottomRight: Radius.circular(AppRadii.xl),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xxl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBadge(
                  event.hostMinistry,
                  tone: BadgeTone.brand,
                  icon: Icons.local_activity_rounded,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  event.title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
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

class _EventBody extends StatelessWidget {
  const _EventBody({required this.event});

  final ChurchEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();

    final dateText =
        '${DateFormat.MMMMEEEEd(loc).format(event.startsAt)} · '
        '${DateFormat.jm(loc).format(event.startsAt)}';

    final whenCard = _InfoCard(
      icon: Icons.event_rounded,
      label: l10n.eventsWhen,
      value: dateText,
    );
    final whereCard = _InfoCard(
      icon: Icons.place_rounded,
      label: l10n.eventsLocation,
      value: event.location,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ResponsiveBuilder(
          mobile: (context) => Column(
            children: [
              whenCard,
              const SizedBox(height: AppSpacing.md),
              whereCard,
            ],
          ),
          tablet: (context) => IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: whenCard),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: whereCard),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.groups_rounded,
                color: context.altar.inkSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.eventsHosted(event.hostMinistry),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      l10n.eventsAttendees(event.attendeeCount),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: context.altar.inkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _AttendeeStack(count: event.attendeeCount),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.eventsAbout),
        const SizedBox(height: AppSpacing.sm),
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            event.description,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: context.altar.glassFill,
              borderRadius: AppRadii.brMd,
              border: Border.all(color: context.altar.glassBorder),
            ),
            child: Icon(icon, size: 20, color: AppColors.teal),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: context.altar.inkTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
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

class _AttendeeStack extends StatelessWidget {
  const _AttendeeStack({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    const names = ['Ava Reed', 'Noah Kim', 'Mia Santos'];
    final shown = names.take(count.clamp(0, names.length)).toList();
    if (shown.isEmpty) return const SizedBox.shrink();
    const overlap = 22.0;

    return SizedBox(
      width: overlap * shown.length + 12,
      height: 36,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * overlap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.altar.glassBorder,
                    width: 2,
                  ),
                ),
                child: AltarAvatar(name: shown[i], radius: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventActionBar extends StatelessWidget {
  const _EventActionBar({required this.event});

  final ChurchEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: context.altar.glassFill,
        border: Border(top: BorderSide(color: context.altar.border)),
        boxShadow: AppShadows.soft(
          dark: Theme.of(context).brightness == Brightness.dark,
        ),
      ),
      child: SafeArea(
        top: false,
        child: ContentBounds(
          maxWidth: 760,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (event.isRegistered)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusBadge(
                      l10n.eventsRegistered,
                      tone: BadgeTone.success,
                      icon: Icons.check_circle_rounded,
                    ),
                  )
                else
                  AltarButton(
                    label: l10n.eventsRegistrationCta,
                    icon: Icons.bolt_rounded,
                    size: AltarButtonSize.large,
                    expand: true,
                    onPressed: () =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.eventsRegistered)),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                AltarButton(
                  label: l10n.eventsAddToCalendar,
                  icon: Icons.calendar_month_rounded,
                  variant: AltarButtonVariant.secondary,
                  expand: true,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.eventsAddToCalendar)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.black.withValues(alpha: 0.28),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
