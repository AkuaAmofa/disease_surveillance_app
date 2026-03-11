import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: userAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.danger),
                  const SizedBox(height: AppSpacing.s3),
                  Text(
                    'Could not load profile',
                    style: AppTypography.bodySemi,
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    err.toString(),
                    style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(profileUserProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (user) => ListView(
            children: [
              _ProfileHeader(user: user),
              const SizedBox(height: AppSpacing.s3),
              _SettingsSection(
                children: [
                  _SettingsRow(
                    icon: Icons.person_rounded,
                    iconBg: AppColors.primaryLight,
                    iconColor: AppColors.primary,
                    title: 'Edit Profile',
                    desc: 'Name and account details',
                    onTap: () => context.push('/edit-profile'),
                  ),
                  _SettingsRow(
                    icon: Icons.description_rounded,
                    iconBg: AppColors.blueLight,
                    iconColor: AppColors.blue,
                    title: 'My Submissions',
                    desc: 'Drafts & submitted reports',
                    onTap: () => context.go('/my-submissions'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authControllerProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6, vertical: AppSpacing.s5),
      color: AppColors.surface,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
            child: Center(
              child: Text(
                user.initials,
                style: AppTypography.headingLg.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            user.name.isNotEmpty ? user.name : 'User',
            style: AppTypography.title,
          ),
          if (user.email.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              user.email,
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final List<Widget> children;
  const _SettingsSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String desc;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.desc,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: iconBg, borderRadius: AppRadius.borderSm),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.captionSemi),
                  Text(
                    desc,
                    style: AppTypography.overline.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
