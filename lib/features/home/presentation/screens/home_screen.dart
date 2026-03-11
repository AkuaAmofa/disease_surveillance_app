import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../controllers/home_controller.dart';
import '../widgets/kpi_grid.dart';
import '../widgets/recent_alerts_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(homeControllerProvider.notifier).loadDashboard(),
          child: homeState.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : ListView(
                  children: [
                    const _HomeAppBar(),
                    if (homeState.errorMessage != null) _OfflineBanner(homeState.errorMessage!),
                    const SizedBox(height: AppSpacing.s3),
                    _SituationBanner(level: homeState.situationLevel),
                    const SizedBox(height: AppSpacing.s3),
                    KpiGrid(summary: homeState.summary),
                    const SizedBox(height: AppSpacing.s3),
                    const _TrendChartCard(),
                    const SizedBox(height: AppSpacing.s3),
                    RecentAlertsSection(alerts: homeState.recentAlerts),
                    const SizedBox(height: AppSpacing.s3),
                    const _DataQualityStrip(),
                    const SizedBox(height: AppSpacing.s6),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: AppTypography.appBarTitle),
                Text('Greater Accra Region', style: AppTypography.appBarSubtitle),
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.notifications_rounded,
            showDotBadge: true,
            onTap: () {
              // TODO: Endpoint not available in backend yet. Notifications screen.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
          const SizedBox(width: AppSpacing.s2),
          AppIconButton(
            icon: Icons.search_rounded,
            onTap: () => context.push('/search'),
          ),
        ],
      ),
    );
  }
}

class _SituationBanner extends StatelessWidget {
  final String level;
  const _SituationBanner({required this.level});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon, text, borderColor) = switch (level) {
      'alert' => (
          AppColors.dangerBg,
          const Color(0xFF7F1D1D),
          Icons.error_rounded,
          'Alert — elevated disease activity detected',
          AppColors.dangerBorder,
        ),
      'watch' => (
          AppColors.warningBg,
          const Color(0xFF78350F),
          Icons.visibility_rounded,
          'Watch — monitoring increased case reports',
          AppColors.warningBorder,
        ),
      _ => (
          AppColors.successBg,
          const Color(0xFF14532D),
          Icons.check_circle_rounded,
          'Normal — all indicators within expected range',
          AppColors.successBorder,
        ),
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderBase,
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChartCard extends StatelessWidget {
  const _TrendChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.borderBase,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Text('Cases Trend', style: AppTypography.bodyBold),
              ],
            ),
          ),
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryXLight, AppColors.surface],
              ),
            ),
            child: CustomPaint(painter: _TrendPainter()),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.55),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.45, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.15),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DataQualityStrip extends StatelessWidget {
  const _DataQualityStrip();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Row(
        children: const [
          _DqItem(value: '94%', label: 'COMPLETENESS'),
          SizedBox(width: AppSpacing.s2),
          _DqItem(value: '98%', label: 'TIMELINESS'),
          SizedBox(width: AppSpacing.s2),
          _DqItem(value: '2', label: 'DUPLICATES'),
        ],
      ),
    );
  }
}

class _DqItem extends StatelessWidget {
  final String value;
  final String label;
  const _DqItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.borderSm,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  final String message;
  const _OfflineBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3, vertical: AppSpacing.s2),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 14, color: AppColors.warning),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
