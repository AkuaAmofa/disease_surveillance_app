import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Search bar matching .m-search-bar from the prototype.
class AppSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const AppSearchBar({
    super.key,
    this.hint = 'Search...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 13, color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textPlaceholder, fontSize: 13),
          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s3,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderBase,
            borderSide: const BorderSide(color: AppColors.border, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderBase,
            borderSide: const BorderSide(color: AppColors.border, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderBase,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
