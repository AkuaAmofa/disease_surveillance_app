import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const _tabs = [
    _TabDef(icon: Icons.home_rounded, label: 'Home'),
    _TabDef(icon: Icons.description_rounded, label: 'Submissions'),
    _TabDef(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppSpacing.s12,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.blue,
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Opacity(opacity: 0.3, child: const SizedBox.expand()),
                  ),
                ),
                Row(
                  children: List.generate(_tabs.length, (i) {
                    final tab = _tabs[i];
                    final isActive = i == navigationShell.currentIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => navigationShell.goBranch(
                          i,
                          initialLocation: i == navigationShell.currentIndex,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.s2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                tab.icon,
                                size: 22,
                                color: isActive ? AppColors.primary : AppColors.textMuted,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabDef {
  final IconData icon;
  final String label;
  const _TabDef({required this.icon, required this.label});
}
