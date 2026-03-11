import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale extracted from the HTML design system.
/// Uses Inter via Google Fonts, matching the prototype exactly.
abstract final class AppTypography {
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // ── Display: 34px / 800 / -0.02em ─────────────────────
  static TextStyle get display => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.68,
        color: AppColors.text,
      );

  // ── Heading XL: 28px / 800 / -0.02em ──────────────────
  static TextStyle get headingXl => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.56,
        color: AppColors.text,
      );

  // ── Heading LG: 24px / 800 / -0.02em ──────────────────
  static TextStyle get headingLg => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.48,
        color: AppColors.text,
      );

  // ── Heading MD: 20px / 700 ─────────────────────────────
  static TextStyle get headingMd => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      );

  // ── Title: 17px / 600 ──────────────────────────────────
  static TextStyle get title => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      );

  // ── Body: 15px / 400 / 1.5 ─────────────────────────────
  static TextStyle get body => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.text,
      );

  // ── Body Semi: 15px / 600 ──────────────────────────────
  static TextStyle get bodySemi => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      );

  // ── Body Bold: 15px / 700 ──────────────────────────────
  static TextStyle get bodyBold => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.15,
        color: AppColors.text,
      );

  // ── Caption: 13px / 500 ────────────────────────────────
  static TextStyle get caption => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  // ── Caption Semi: 13px / 600 ───────────────────────────
  static TextStyle get captionSemi => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      );

  // ── Overline: 11px / 600 / UPPER ───────────────────────
  static TextStyle get overline => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.66,
        color: AppColors.textMuted,
      );

  // ── Tiny: 10px / 600 / UPPER (KPI labels) ─────────────
  static TextStyle get tiny => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: AppColors.textMuted,
      );

  // ── App bar title: 20px / 800 / -0.02em ────────────────
  static TextStyle get appBarTitle => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: AppColors.text,
      );

  // ── App bar subtitle: 11px / 400 ───────────────────────
  static TextStyle get appBarSubtitle => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );
}
