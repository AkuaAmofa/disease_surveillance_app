import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../data/models/report_model.dart';
import '../controllers/submissions_controller.dart';

class MySubmissionsScreen extends ConsumerWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(submissionsTabProvider);
    final state = ref.watch(mySubmissionsProvider);
    final drafts = state.drafts;
    final submitted = state.submitted;
    final items = tabIndex == 0 ? drafts : submitted;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              child: AppSegmentedControl(
                segments: ['Drafts (${drafts.length})', 'Submitted (${submitted.length})'],
                selectedIndex: tabIndex,
                onChanged: (i) => ref.read(submissionsTabProvider.notifier).state = i,
              ),
            ),
            const SizedBox(height: AppSpacing.s3),
            Expanded(child: _buildBody(context, ref, state, items)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MySubmissionsState state,
    List<ReportModel> items,
  ) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.s4),
            Text('Loading submissions...'),
          ],
        ),
      );
    }

    if (state.errorMessage != null && state.reports.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textMuted),
              const SizedBox(height: AppSpacing.s4),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s4),
              FilledButton.icon(
                onPressed: () => ref.read(mySubmissionsProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      final tabIndex = ref.watch(submissionsTabProvider);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tabIndex == 0 ? Icons.drafts_rounded : Icons.check_circle_outline_rounded,
                size: 48,
                color: AppColors.textMuted,
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                tabIndex == 0 ? 'No drafts yet' : 'No submitted reports yet',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(mySubmissionsProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.s4),
        itemCount: items.length,
        itemBuilder: (_, i) => _SubmissionCard(report: items[i], state: state),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
      child: Row(
        children: [
          Expanded(child: Text('My Submissions', style: AppTypography.appBarTitle)),
          SizedBox(
            height: 36,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/report-case'),
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

class _SubmissionCard extends StatelessWidget {
  final ReportModel report;
  final MySubmissionsState state;
  const _SubmissionCard({required this.report, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDraft = report.status == state.draftStatusId;
    final disease = state.diseaseName(report.disease);
    final location = state.locationName(report.location);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s1 + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.borderBase,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isDraft ? AppColors.warning : AppColors.success),
                ),
                const SizedBox(width: AppSpacing.s2),
                Expanded(child: Text('$disease — $location', style: AppTypography.captionSemi)),
                AppBadge(label: isDraft ? 'Draft' : 'Submitted', variant: isDraft ? BadgeVariant.warning : BadgeVariant.success),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Column(
              children: [
                _MetaGrid(report: report, state: state),
                const SizedBox(height: AppSpacing.s3),
                SizedBox(
                  width: double.infinity, height: 36,
                  child: isDraft
                      ? OutlinedButton.icon(
                          onPressed: () => context.push('/edit-draft/${report.id}'),
                          icon: const Icon(Icons.edit_rounded, size: 15),
                          label: const Text('Edit Draft'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            backgroundColor: AppColors.warningBg,
                            side: BorderSide(color: AppColors.warning.withValues(alpha: 0.25)),
                            foregroundColor: const Color(0xFF92400E),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        )
                      : OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.lock_rounded, size: 15),
                          label: const Text('Read-only'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            backgroundColor: AppColors.background,
                            side: const BorderSide(color: AppColors.border),
                            foregroundColor: AppColors.textMuted,
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
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

class _MetaGrid extends StatelessWidget {
  final ReportModel report;
  final MySubmissionsState state;
  const _MetaGrid({required this.report, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MetaItem(label: 'Cases', value: report.caseCount.toString())),
        Expanded(child: _MetaItem(label: 'Observed', value: state.formatDate(report.observedAt))),
        Expanded(child: _MetaItem(label: 'Submitted', value: state.formatDate(report.submittedAt))),
        Expanded(child: _MetaItem(label: 'Source', value: state.sourceName(report.reportSource))),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTypography.tiny.copyWith(fontSize: 9)),
        const SizedBox(height: 1),
        Text(
          value,
          style: value == '—'
              ? AppTypography.overline.copyWith(color: AppColors.textMuted, letterSpacing: 0)
              : AppTypography.captionSemi.copyWith(fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
