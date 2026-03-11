import 'package:flutter/material.dart';

/// Border-radius tokens extracted from the HTML design system.
/// Maps to CSS custom properties (--t-r-*).
abstract final class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double base = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 100;

  static BorderRadius get borderXs => BorderRadius.circular(xs);
  static BorderRadius get borderSm => BorderRadius.circular(sm);
  static BorderRadius get borderBase => BorderRadius.circular(base);
  static BorderRadius get borderLg => BorderRadius.circular(lg);
  static BorderRadius get borderXl => BorderRadius.circular(xl);
  static BorderRadius get borderPill => BorderRadius.circular(pill);
}
