import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum SituationLevel { normal, watch, alert }

/// Colored situation banner matching .m-situation-banner from the prototype.
class AppSituationBanner extends StatelessWidget {
  final SituationLevel level;
  final String message;

  const AppSituationBanner({
    super.key,
    required this.level,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final (bg, fg, borderColor, icon) = _config;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderBase,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              message,
              style: AppTypography.captionSemi.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color, IconData) get _config => switch (level) {
        SituationLevel.normal => (
            AppColors.successBg,
            const Color(0xFF14532D),
            AppColors.successBorder,
            Icons.check_circle_rounded,
          ),
        SituationLevel.watch => (
            AppColors.warningBg,
            const Color(0xFF78350F),
            AppColors.warningBorder,
            Icons.visibility_rounded,
          ),
        SituationLevel.alert => (
            AppColors.dangerBg,
            const Color(0xFF7F1D1D),
            AppColors.dangerBorder,
            Icons.warning_rounded,
          ),
      };
}
