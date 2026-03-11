import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

/// 40×40 icon button matching .m-icon-btn from the prototype.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool showDotBadge;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.showBorder = true,
    this.showDotBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderSm,
          border: showBorder ? Border.all(color: AppColors.border) : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.textMuted),
            if (showDotBadge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
