import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/feature_two/presentation/screens/my_submissions_screen.dart';
import '../../features/feature_two/presentation/screens/report_case_screen.dart';
import '../../features/home/presentation/screens/home_cards_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared/widgets/app_shell.dart';

part 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final isAuthPage = path == RouteNames.splash ||
          path == RouteNames.login ||
          path == RouteNames.signUp;

      if (!isAuthenticated && !isAuthPage) return RouteNames.login;
      if (isAuthenticated && (path == RouteNames.login || path == RouteNames.signUp)) {
        return RouteNames.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signUp,
        builder: (_, _) => const SignUpScreen(),
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: HomeCardsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.mySubmissions,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: MySubmissionsScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: ProfileScreen()),
              ),
            ],
          ),
        ],
      ),

      // Full-screen routes pushed over the shell
      GoRoute(
        path: RouteNames.reportCase,
        builder: (_, _) => const ReportCaseScreen(),
      ),
      GoRoute(
        path: RouteNames.editDraft,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return ReportCaseScreen(editReportId: id);
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (_, _) => const EditProfileScreen(),
      ),
    ],
  );
});
