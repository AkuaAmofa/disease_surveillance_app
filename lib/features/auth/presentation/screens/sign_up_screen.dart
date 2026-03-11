import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

// TODO: Endpoint not available in backend yet. Sign-up is handled via Django admin / allauth web.
// This screen is a placeholder that informs the user.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppRadius.borderBase,
                      ),
                      child: const Icon(Icons.person_add_rounded, size: 28, color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text('Create Account', style: AppTypography.appBarTitle),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      'Join the surveillance network',
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Full Name',
                        style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.s1),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Dr. Kwame Mensah'),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text('Email Address',
                        style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.s1),
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'you@health.gov.gh'),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text('Password',
                        style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.s1),
                    const TextField(
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Create password'),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s3),
                      decoration: BoxDecoration(
                        color: AppColors.warningBg,
                        borderRadius: AppRadius.borderSm,
                        border: Border.all(color: AppColors.warningBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.warning),
                          const SizedBox(width: AppSpacing.s2),
                          Expanded(
                            child: Text(
                              'Account creation requires admin approval. Contact your supervisor.',
                              style: AppTypography.overline.copyWith(
                                color: AppColors.textSecondary,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign-up requires admin provisioning. Contact your supervisor.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_add_rounded, size: 18),
                        label: const Text('Request Account',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        'Sign In',
                        style: AppTypography.captionSemi.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
