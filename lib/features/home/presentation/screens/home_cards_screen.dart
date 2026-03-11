import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class HomeCardsScreen extends StatelessWidget {
  const HomeCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.s4),
              Text(AppConstants.appName, style: AppTypography.headingLg),
              const SizedBox(height: AppSpacing.s1),
              Text(
                AppConstants.appSubtitle,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.s7),
              _FeatureCard(
                icon: Icons.add_circle_rounded,
                title: 'Report Case',
                subtitle: 'Submit a new disease case report or save as draft',
                accentColor: AppColors.primary,
                bgColor: AppColors.primaryXLight,
                onTap: () => context.push('/report-case'),
              ),
              const SizedBox(height: AppSpacing.s4),
              _FeatureCard(
                icon: Icons.description_rounded,
                title: 'My Submissions',
                subtitle: 'View, edit drafts, and track submitted reports',
                accentColor: AppColors.blue,
                bgColor: AppColors.blueLight,
                onTap: () => context.go('/my-submissions'),
              ),
              const SizedBox(height: AppSpacing.s4),
              _FeatureCard(
                icon: Icons.person_rounded,
                title: 'Profile',
                subtitle: 'Account settings and app preferences',
                accentColor: AppColors.textSecondary,
                bgColor: AppColors.neutralBg,
                onTap: () => context.go('/profile'),
              ),
              const Spacer(),
              Center(
                child: Text(
                  AppConstants.appVersion,
                  style: AppTypography.tiny.copyWith(color: AppColors.textPlaceholder),
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.borderLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s5),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: AppRadius.borderBase,
                ),
                child: Icon(icon, color: accentColor, size: 26),
              ),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.bodySemi),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textPlaceholder, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
