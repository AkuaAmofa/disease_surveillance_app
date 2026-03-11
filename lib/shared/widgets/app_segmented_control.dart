import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Segmented control matching .m-segmented from the prototype.
class AppSegmentedControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(segments.length, (i) {
          final isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.s2,
                  horizontal: AppSpacing.s3,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isActive ? AppShadows.xs : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  segments[i],
                  style: AppTypography.overline.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textMuted,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
