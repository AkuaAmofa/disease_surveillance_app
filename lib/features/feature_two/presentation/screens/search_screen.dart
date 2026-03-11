import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_chip.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../controllers/search_controller.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(appSearchControllerProvider);
    final controller = ref.read(appSearchControllerProvider.notifier);
    final recentSearches = ref.watch(recentSearchesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(onChanged: controller.setQuery, onCancel: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpacing.s12 + AppSpacing.s4),
                children: [
                  _SectionLabel('Recent'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                    child: Wrap(
                      spacing: AppSpacing.s2,
                      runSpacing: AppSpacing.s2,
                      children: recentSearches.map((s) => AppChip(label: s, onTap: () => controller.setQuery(s))).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  _SectionLabel('Filter by'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date Range', style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.s2),
                        AppSegmentedControl(
                          segments: const ['7 Days', '30 Days', '90 Days', 'Custom'],
                          selectedIndex: searchState.dateRangeIndex,
                          onChanged: controller.setDateRange,
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text('Disease', style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.s2),
                        Wrap(
                          spacing: AppSpacing.s2,
                          runSpacing: AppSpacing.s2,
                          children: ['All', ...AppConstants.diseases].map((d) {
                            return AppChip(label: d, isActive: searchState.diseaseFilter == d, onTap: () => controller.setDisease(d));
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text('Severity', style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.s2),
                        Wrap(
                          spacing: AppSpacing.s2,
                          runSpacing: AppSpacing.s2,
                          children: ['All', 'Low', 'Medium', 'High', 'Critical'].map((s) {
                            return AppChip(label: s, isActive: searchState.severityFilter == s, onTap: () => controller.setSeverity(s));
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        Text('Location', style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: AppSpacing.s2),
                        DropdownButtonFormField<String>(
                          initialValue: searchState.locationFilter,
                          items: ['All Locations', ...AppConstants.locations].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (v) => controller.setLocation(v ?? 'All Locations'),
                          decoration: const InputDecoration(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => controller.reset(), child: const Text('Reset'))),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Apply Filters'),
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

class _SearchHeader extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onCancel;

  const _SearchHeader({required this.onChanged, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              autofocus: true,
              style: const TextStyle(fontSize: 15, color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Search diseases, locations...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(borderRadius: AppRadius.borderBase, borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: AppRadius.borderBase, borderSide: const BorderSide(color: AppColors.border)),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          GestureDetector(
            onTap: onCancel,
            child: Text('Cancel', style: AppTypography.captionSemi.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s2),
      child: Text(text.toUpperCase(), style: AppTypography.tiny.copyWith(fontSize: 9, letterSpacing: 0.6)),
    );
  }
}
