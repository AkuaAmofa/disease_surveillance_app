import 'package:flutter/material.dart';

/// Centralized color tokens extracted from the HTML design system.
/// Maps directly to CSS custom properties (--t-*).
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1B8A78);
  static const Color primaryDark = Color(0xFF14705F);
  static const Color primaryMid = Color(0xFF21A88F);
  static const Color primaryLight = Color(0xFFE6F7F4);
  static const Color primaryXLight = Color(0xFFF0FBF8);

  static const Color blue = Color(0xFF3B82F6);
  static const Color blueDark = Color(0xFF2563EB);
  static const Color blueLight = Color(0xFFEFF6FF);

  // ── Surfaces ───────────────────────────────────────────
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceHover = Color(0xFFFAFCFF);

  // ── Borders ────────────────────────────────────────────
  static const Color border = Color(0xFFE8ECF0);
  static const Color borderStrong = Color(0xFFD1D9E0);

  // ── Typography ─────────────────────────────────────────
  static const Color text = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF3D5166);
  static const Color textMuted = Color(0xFF7A8FA6);
  static const Color textPlaceholder = Color(0xFFAAB7C4);

  // ── Semantic ───────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successBorder = Color(0x3316A34A);

  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0x33D97706);

  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerBorder = Color(0x33DC2626);

  static const Color info = Color(0xFF0284C7);
  static const Color infoBg = Color(0xFFE0F2FE);
  static const Color infoBorder = Color(0x330284C7);

  static const Color critical = Color(0xFF7E22CE);
  static const Color criticalBg = Color(0xFFF3E8FF);
  static const Color criticalBorder = Color(0x337E22CE);

  // ── Extra (used in KPI cards) ──────────────────────────
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberDark = Color(0xFFD97706);
  static const Color red = Color(0xFFEF4444);

  // ── Neutral chip ───────────────────────────────────────
  static const Color neutralBg = Color(0xFFF1F5F9);
  static const Color neutralText = Color(0xFF475569);
  static const Color neutralBorder = Color(0xFFE2E8F0);
}
