import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:altar/core/design_system.dart';
import 'package:altar/core/localization/l10n_extension.dart';
import 'package:altar/app/providers.dart';
import 'package:altar/data/mock/mock_data.dart';
import 'package:altar/data/models/models.dart';

class GivingScreen extends ConsumerStatefulWidget {
  const GivingScreen({super.key});

  @override
  ConsumerState<GivingScreen> createState() => _GivingScreenState();
}

class _GivingScreenState extends ConsumerState<GivingScreen> {
  static const List<int> _presets = [25, 50, 100, 250];

  int _amount = 50;
  GivingFundType _fund = GivingFundType.general;
  GivingFrequency _frequency = GivingFrequency.oneTime;

  String _currency(int cents) =>
      NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(cents / 100);

  String _fundLabel(BuildContext context, GivingFundType fund) {
    final l10n = context.l10n;
    switch (fund) {
      case GivingFundType.general:
        return l10n.givingFundGeneral;
      case GivingFundType.missions:
        return l10n.givingFundMissions;
      case GivingFundType.building:
        return l10n.givingFundBuilding;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);

    final thisMonthCents = user?.givenThisMonthCents ?? 0;

    final body = ListView(
      padding: AppSpacing.pagePadding,
      children: [
        _GiveNowHero(
          amountLabel: _currency(_amount * 100),
          presets: _presets,
          selectedAmount: _amount,
          onAmountSelected: (v) => setState(() => _amount = v),
          fund: _fund,
          onFundSelected: (f) => setState(() => _fund = f),
          fundLabel: _fundLabel,
          frequency: _frequency,
          onFrequencySelected: (f) => setState(() => _frequency = f),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SummaryRow(
          thisMonth: _currency(thisMonthCents),
          yearToDate: _currency(MockData.givingYearToDateCents),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.givingHistory),
        const SizedBox(height: AppSpacing.sm),
        for (final record in MockData.givingHistory) ...[
          _GivingHistoryTile(
            amount: _currency(record.amountCents),
            fundName: _fundLabel(context, record.fund),
            dateLabel: DateFormat.MMMEd(
              Localizations.localeOf(context).toString(),
            ).format(record.date),
            method: record.method,
            isRecurring: record.frequency == GivingFrequency.monthly,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.md),
        AltarButton(
          label: l10n.givingTaxStatement,
          icon: Icons.description_outlined,
          variant: AltarButtonVariant.secondary,
          expand: true,
          onPressed: () {},
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );

    if (context.isDesktop) {
      return ContentBounds(maxWidth: 820, child: body);
    }
    return body;
  }
}

class _GiveNowHero extends StatelessWidget {
  const _GiveNowHero({
    required this.amountLabel,
    required this.presets,
    required this.selectedAmount,
    required this.onAmountSelected,
    required this.fund,
    required this.onFundSelected,
    required this.fundLabel,
    required this.frequency,
    required this.onFrequencySelected,
  });

  final String amountLabel;
  final List<int> presets;
  final int selectedAmount;
  final ValueChanged<int> onAmountSelected;
  final GivingFundType fund;
  final ValueChanged<GivingFundType> onFundSelected;
  final String Function(BuildContext, GivingFundType) fundLabel;
  final GivingFrequency frequency;
  final ValueChanged<GivingFrequency> onFrequencySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: LinearGradient(
        colors: context.altar.brandGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      glow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.givingTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            amountLabel,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final preset in presets)
                _HeroChip(
                  label: '\$$preset',
                  selected: preset == selectedAmount,
                  onTap: () => onAmountSelected(preset),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.givingFund,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final f in GivingFundType.values)
                _HeroChip(
                  label: fundLabel(context, f),
                  selected: f == fund,
                  onTap: () => onFundSelected(f),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.givingFrequency,
            style: theme.textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: _HeroChip(
                  label: l10n.givingOneTime,
                  selected: frequency == GivingFrequency.oneTime,
                  onTap: () => onFrequencySelected(GivingFrequency.oneTime),
                  expand: true,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _HeroChip(
                  label: l10n.givingMonthly,
                  selected: frequency == GivingFrequency.monthly,
                  onTap: () => onFrequencySelected(GivingFrequency.monthly),
                  expand: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AltarButton(
            label: l10n.givingGiveNow,
            icon: Icons.favorite_outline,
            size: AltarButtonSize.large,
            expand: true,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 14,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              const SizedBox(width: AppSpacing.xxs),
              Flexible(
                child: Text(
                  l10n.givingSecure,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.expand = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadii.brMd,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          alignment: expand ? Alignment.center : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.16),
            borderRadius: AppRadii.brMd,
            border: Border.all(
              color: Colors.white.withValues(alpha: selected ? 0 : 0.35),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected ? AppColors.tealDeep : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.thisMonth, required this.yearToDate});

  final String thisMonth;
  final String yearToDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: StatCard(
            label: l10n.givingThisMonth,
            value: thisMonth,
            icon: Icons.calendar_month_outlined,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: StatCard(
            label: l10n.givingYearToDate,
            value: yearToDate,
            icon: Icons.savings_outlined,
          ),
        ),
      ],
    );
  }
}

class _GivingHistoryTile extends StatelessWidget {
  const _GivingHistoryTile({
    required this.amount,
    required this.fundName,
    required this.dateLabel,
    required this.method,
    required this.isRecurring,
  });

  final String amount;
  final String fundName;
  final String dateLabel;
  final String method;
  final bool isRecurring;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: context.altar.brandGradient),
              borderRadius: AppRadii.brMd,
            ),
            child: const Icon(
              Icons.volunteer_activism_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fundName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isRecurring) ...[
                      const SizedBox(width: AppSpacing.xs),
                      StatusBadge(
                        l10n.givingRecurring,
                        tone: BadgeTone.brand,
                        icon: Icons.autorenew,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '$dateLabel · $method',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.altar.inkSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            amount,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
