import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/core/navigation/routes.dart';
import 'package:altar/core/rbac/permissions.dart';
import 'package:altar/app/providers.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider) ?? MockData.defaultUser;
    final rbac = ref.watch(rbacProvider);
    final canServe = rbac.can(AppPermission.serve);
    final nextAssignment = MockData.nextAssignment;

    final sections = <Widget>[
      _GreetingHeader(user: user),
      if (canServe) _ServingBanner(assignment: nextAssignment),
      const _SpecialEvents(),
      const _Announcements(),
    ];

    final children = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      children.add(sections[i]);
      if (i != sections.length - 1) {
        children.add(const SizedBox(height: AppSpacing.lg));
      }
    }

    final body = SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (context.isDesktop) {
      return ContentBounds(maxWidth: 1000, child: body);
    }
    return body;
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hour = MockData.now.hour;
    final String greetingWord;
    if (hour < 12) {
      greetingWord = l10n.homeGoodMorning;
    } else if (hour < 18) {
      greetingWord = l10n.homeGoodAfternoon;
    } else {
      greetingWord = l10n.homeGoodEvening;
    }

    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greetingWord,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.altar.inkSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                l10n.homeGreeting(user.firstName),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        AltarAvatar(name: user.fullName, imageUrl: user.avatarUrl, radius: 26),
      ],
    );
  }
}

class _ServingBanner extends StatelessWidget {
  const _ServingBanner({required this.assignment});

  final ScheduleAssignment assignment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final altar = context.altar;
    final loc = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.MMMEd(loc).format(assignment.startsAt);

    // Slim, subtle alert — compact vertical padding, a soft teal tint and a
    // single tap target (the whole banner) leading to the assignment.
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.teal.withValues(alpha: 0.10),
          AppColors.aqua.withValues(alpha: 0.04),
        ],
      ),
      onTap: () => context.go(Routes.schedule),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.teal.withValues(alpha: 0.14),
              borderRadius: AppRadii.brSm,
            ),
            child: const Icon(Icons.event_available_rounded,
                color: AppColors.teal, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.scheduleNextServe,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: altar.inkSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${assignment.role} • ${assignment.eventTitle}',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  dateLabel,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: altar.inkTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          // Compact "view assignment" affordance.
          Tooltip(
            message: l10n.homeServingCta,
            child: Icon(Icons.chevron_right_rounded,
                color: altar.inkTertiary, size: 22),
          ),
        ],
      ),
    );
  }
}

class _SpecialEvents extends StatelessWidget {
  const _SpecialEvents();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final events = <ChurchEvent>[
      ...MockData.specialEvents,
      ...MockData.events.take(2),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.homeSpecialEvents,
          actionLabel: l10n.actionSeeAll,
          onAction: () => context.go(Routes.events),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: events.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) =>
                _EventPosterCard(event: events[index]),
          ),
        ),
      ],
    );
  }
}

class _EventPosterCard extends StatelessWidget {
  const _EventPosterCard({required this.event});

  final ChurchEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final dateLabel =
        '${DateFormat.MMMEd(loc).format(event.startsAt)} · ${DateFormat.jm(loc).format(event.startsAt)}';

    final posterColors = event.posterColors.isNotEmpty
        ? event.posterColors
        : AppColors.brandGradient;

    return SizedBox(
      width: 260,
      child: GlassCard(
        onTap: () => context.push(Routes.eventDetailFor(event.id)),
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: posterColors,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadii.lg),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              alignment: Alignment.bottomLeft,
              child: Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(
                    l10n.homeSpecialEvents,
                    tone: BadgeTone.brand,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    dateLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.altar.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Announcements extends StatelessWidget {
  const _Announcements();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final announcements = MockData.announcements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.homeAnnouncements),
        const SizedBox(height: AppSpacing.sm),
        for (var i = 0; i < announcements.length; i++) ...[
          _AnnouncementCard(announcement: announcements[i]),
          if (i != announcements.length - 1)
            const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loc = Localizations.localeOf(context).toString();
    final timeLabel = DateFormat.MMMEd(loc).format(announcement.postedAt);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  announcement.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (announcement.pinned) ...[
                const SizedBox(width: AppSpacing.xs),
                StatusBadge(
                  l10n.homeAnnouncements,
                  tone: BadgeTone.brand,
                  icon: Icons.push_pin,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            announcement.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.altar.inkSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            timeLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.altar.inkTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
