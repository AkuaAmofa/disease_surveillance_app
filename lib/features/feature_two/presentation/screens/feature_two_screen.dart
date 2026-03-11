import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_list_item.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../controllers/reports_controller.dart';

class FeatureTwoScreen extends ConsumerWidget {
  const FeatureTwoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final activeChip = ref.watch(activeFilterChipProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _AppBar(),
            const SizedBox(height: AppSpacing.s2),
            const AppSearchBar(hint: 'Search reports...'),
            const SizedBox(height: AppSpacing.s3),
            _ChipRow(activeChip: activeChip, ref: ref),
            const SizedBox(height: AppSpacing.s2),
            Expanded(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (_, i) {
                  final r = reports[i];
                  return AppListItem(
                    icon: Icons.description_rounded,
                    iconBg: _diseaseColor(r.disease).$1,
                    iconColor: _diseaseColor(r.disease).$2,
                    title: '${r.disease} — ${r.location}',
                    subtitle: '${r.cases} cases · ${r.reporter} · ${r.timeAgo}',
                    trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _diseaseColor(String disease) => switch (disease) {
        'Cholera' => (AppColors.dangerBg, AppColors.danger),
        'Dengue' => (AppColors.blueLight, AppColors.blue),
        'COVID-19' => (AppColors.warningBg, AppColors.warning),
        _ => (AppColors.primaryLight, AppColors.primary),
      };
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
      child: Row(
        children: [
          Expanded(child: Text('Reports', style: AppTypography.appBarTitle)),
          SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('New'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 36),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final String activeChip;
  final WidgetRef ref;

  const _ChipRow({required this.activeChip, required this.ref});

  @override
  Widget build(BuildContext context) {
    const chips = ['All', 'Malaria', 'Cholera', 'Dengue', 'COVID-19'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s2),
        itemBuilder: (_, i) => AppChip(
          label: chips[i],
          isActive: activeChip == chips[i],
          onTap: () => ref.read(activeFilterChipProvider.notifier).state = chips[i],
        ),
      ),
    );
  }
}
