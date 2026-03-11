import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/models/dashboard_summary_model.dart';

class RecentAlertsSection extends StatelessWidget {
  final List<RecentAlert> alerts;
  const RecentAlertsSection({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.borderBase,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Text('Recent Alerts', style: AppTypography.bodyBold),
              ],
            ),
          ),
          if (alerts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      size: 32, color: AppColors.borderStrong),
                  const SizedBox(height: AppSpacing.s2),
                  Text('No recent alerts',
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
                ],
              ),
            )
          else
            ...alerts.map((alert) => _AlertRow(alert: alert)),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final RecentAlert alert;
  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final (iconBg, iconColor) = _severityColors(alert.severity);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(Icons.warning_rounded, size: 18, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.diseaseName} — ${alert.locationName}',
                  style: AppTypography.captionSemi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  alert.createdAt,
                  style: AppTypography.overline.copyWith(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadius.borderPill,
              border: Border.all(color: iconColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              alert.severity.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _severityColors(String severity) => switch (severity.toLowerCase()) {
        'high' || 'critical' => (AppColors.dangerBg, AppColors.danger),
        'medium' => (AppColors.warningBg, AppColors.warning),
        _ => (AppColors.successBg, AppColors.success),
      };
}
