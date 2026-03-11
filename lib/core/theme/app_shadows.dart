import 'package:flutter/material.dart';

/// Shadow tokens extracted from the HTML design system.
/// Maps to CSS custom properties (--t-shadow-*).
abstract final class AppShadows {
  static const Color _base = Color(0xFF0D1B2A);

  static List<BoxShadow> get xs => [
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 2,
          color: _base.withValues(alpha: 0.04),
        ),
      ];

  static List<BoxShadow> get sm => [
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 6,
          color: _base.withValues(alpha: 0.06),
        ),
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 2,
          color: _base.withValues(alpha: 0.04),
        ),
      ];

  static List<BoxShadow> get base => [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 16,
          color: _base.withValues(alpha: 0.07),
        ),
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 4,
          color: _base.withValues(alpha: 0.04),
        ),
      ];

  static List<BoxShadow> get lg => [
        BoxShadow(
          offset: const Offset(0, 8),
          blurRadius: 28,
          color: _base.withValues(alpha: 0.10),
        ),
        BoxShadow(
          offset: const Offset(0, 2),
          blurRadius: 8,
          color: _base.withValues(alpha: 0.05),
        ),
      ];

  static List<BoxShadow> get xl => [
        BoxShadow(
          offset: const Offset(0, 16),
          blurRadius: 48,
          color: _base.withValues(alpha: 0.13),
        ),
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 12,
          color: _base.withValues(alpha: 0.06),
        ),
      ];
}
