import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/dashboard_summary_model.dart';

class KpiGrid extends StatelessWidget {
  final DashboardSummary summary;
  const KpiGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.s3,
        crossAxisSpacing: AppSpacing.s3,
        childAspectRatio: 1.6,
        children: [
          _KpiCard(
            label: 'CASES (7D)',
            value: summary.cases7d.toString(),
            accentColor: AppColors.primary,
          ),
          _KpiCard(
            label: 'CASES (30D)',
            value: summary.cases30d.toString(),
            accentColor: AppColors.blue,
          ),
          _KpiCard(
            label: 'REPORTS (7D)',
            value: summary.reports7d.toString(),
            accentColor: const Color(0xFFF59E0B),
          ),
          _KpiCard(
            label: 'ACTIVE ALERTS',
            value: summary.activeAlerts.toString(),
            accentColor: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.borderBase,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 3, color: accentColor),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.72,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
