import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// Semantic status badge matching the prototype's .m-badge.
enum BadgeVariant { success, warning, danger, info, critical, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;

  const AppBadge({super.key, required this.label, required this.variant});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, borderColor) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: fg,
        ),
      ),
    );
  }

  (Color, Color, Color) get _colors => switch (variant) {
        BadgeVariant.success => (AppColors.successBg, AppColors.success, AppColors.successBorder),
        BadgeVariant.warning => (AppColors.warningBg, AppColors.warning, AppColors.warningBorder),
        BadgeVariant.danger => (AppColors.dangerBg, AppColors.danger, AppColors.dangerBorder),
        BadgeVariant.info => (AppColors.infoBg, AppColors.info, AppColors.infoBorder),
        BadgeVariant.critical => (AppColors.criticalBg, AppColors.critical, AppColors.criticalBorder),
        BadgeVariant.neutral => (AppColors.neutralBg, AppColors.neutralText, AppColors.neutralBorder),
      };
}
