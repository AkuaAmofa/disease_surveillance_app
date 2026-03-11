import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';

/// Toggle switch matching .m-toggle from the prototype.
class AppToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : AppColors.borderStrong,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppShadows.sm,
            ),
          ),
        ),
      ),
    );
  }
}
