import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Filter chip matching .m-chip from the prototype.
class AppChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s2,
          horizontal: AppSpacing.s3,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryLight : Colors.transparent,
          borderRadius: AppRadius.borderPill,
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.borderStrong,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
