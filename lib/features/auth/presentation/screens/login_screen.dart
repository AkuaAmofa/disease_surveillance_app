import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s8),
              const _BrandHeader(),
              const SizedBox(height: AppSpacing.s4),
              _LoginForm(
                authState: authState,
                controller: controller,
                onLogin: () async {
                  final success = await controller.login();
                  if (success && context.mounted) {
                    context.go('/');
                  }
                },
              ),
              const SizedBox(height: AppSpacing.s6),
              _SignUpLink(
                onTap: () => context.push('/sign-up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: const Icon(Icons.coronavirus_rounded, size: 28, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text('Welcome Back', style: AppTypography.appBarTitle),
          const SizedBox(height: AppSpacing.s1),
          Text(
            'Sign in to continue monitoring',
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final AuthState authState;
  final AuthController controller;
  final VoidCallback onLogin;

  const _LoginForm({
    required this.authState,
    required this.controller,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email Address',
              style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s1),
          TextField(
            onChanged: controller.setEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'you@health.gov.gh'),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text('Password',
              style: AppTypography.overline.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.s1),
          TextField(
            onChanged: controller.setPassword,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter password'),
          ),
          const SizedBox(height: AppSpacing.s4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: controller.toggleRememberMe,
                child: Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: Checkbox(
                        value: authState.rememberMe,
                        onChanged: (_) => controller.toggleRememberMe(),
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primary;
                          }
                          return Colors.transparent;
                        }),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    Text('Remember me', style: AppTypography.overline),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Endpoint not available in backend yet. Forgot password flow.
                },
                child: Text(
                  'Forgot?',
                  style: AppTypography.overline.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (authState.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.s3),
            Text(
              authState.errorMessage!,
              style: AppTypography.overline.copyWith(color: AppColors.danger),
            ),
          ],
          const SizedBox(height: AppSpacing.s5),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: authState.isLoading ? null : onLogin,
              icon: authState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.login_rounded, size: 18),
              label: const Text('Sign In',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderBase),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  final VoidCallback onTap;
  const _SignUpLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Sign Up',
              style: AppTypography.captionSemi.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
