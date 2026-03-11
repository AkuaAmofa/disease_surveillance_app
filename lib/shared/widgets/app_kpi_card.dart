import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum KpiVariant { primary, blue, amber, red }

/// KPI metric card matching .m-kpi-card from the prototype.
class AppKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool isChangeUp;
  final bool isChangeNeutral;
  final KpiVariant variant;

  const AppKpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
    this.isChangeUp = false,
    this.isChangeNeutral = false,
    this.variant = KpiVariant.primary,
  });

  Color get _accentColor => switch (variant) {
        KpiVariant.primary => AppColors.primary,
        KpiVariant.blue => AppColors.blue,
        KpiVariant.amber => AppColors.amberDark,
        KpiVariant.red => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.borderBase,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(height: 3, color: _accentColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTypography.tiny,
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                value,
                style: AppTypography.headingLg.copyWith(
                  color: _accentColor,
                  letterSpacing: -0.72,
                  height: 1,
                ),
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                change,
                style: AppTypography.overline.copyWith(
                  color: isChangeNeutral
                      ? AppColors.textMuted
                      : isChangeUp
                          ? AppColors.danger
                          : AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
