import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await ref.read(authControllerProvider.notifier).checkSession();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    context.go(isAuthenticated ? '/' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.5, -1),
            end: Alignment(0.5, 1),
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryMid,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Icon(
                  Icons.coronavirus_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              const Text(
                'Disease\nSurveillance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.48,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                'Ghana Health Service',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.s9),
              SizedBox(
                width: 32,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s9),
              Text(
                'v2.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
