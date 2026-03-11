import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dashboard_summary_model.dart';
import '../../data/repositories/dashboard_repository.dart';

class HomeState {
  final DashboardSummary summary;
  final List<RecentAlert> recentAlerts;
  final bool isLoading;
  final String? errorMessage;
  final String situationLevel;

  const HomeState({
    this.summary = const DashboardSummary(),
    this.recentAlerts = const [],
    this.isLoading = false,
    this.errorMessage,
    this.situationLevel = 'normal',
  });

  HomeState copyWith({
    DashboardSummary? summary,
    List<RecentAlert>? recentAlerts,
    bool? isLoading,
    String? errorMessage,
    String? situationLevel,
  }) {
    return HomeState(
      summary: summary ?? this.summary,
      recentAlerts: recentAlerts ?? this.recentAlerts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      situationLevel: situationLevel ?? this.situationLevel,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final DashboardRepository _repository;

  HomeController(this._repository) : super(const HomeState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await Future.wait([
        _repository.getSummary(),
        _repository.getRecentAlerts(),
      ]);
      final summary = results[0] as DashboardSummary;
      final alerts = results[1] as List<RecentAlert>;
      final level = summary.activeAlerts > 5
          ? 'alert'
          : summary.activeAlerts > 2
              ? 'watch'
              : 'normal';
      state = state.copyWith(
        summary: summary,
        recentAlerts: alerts,
        isLoading: false,
        situationLevel: level,
      );
    } catch (_) {
      state = state.copyWith(
        summary: DashboardSummary.mock,
        recentAlerts: _mockAlerts,
        isLoading: false,
        errorMessage: 'Using cached data — backend unreachable.',
        situationLevel: 'watch',
      );
    }
  }

  static const _mockAlerts = [
    RecentAlert(id: 1, diseaseName: 'Cholera', locationName: 'Ga West', severity: 'high', createdAt: '2 hours ago'),
    RecentAlert(id: 2, diseaseName: 'Malaria', locationName: 'Accra Metro', severity: 'medium', createdAt: '5 hours ago'),
    RecentAlert(id: 3, diseaseName: 'Dengue', locationName: 'Tema Metro', severity: 'low', createdAt: '1 day ago'),
  ];
}

final homeControllerProvider =
    StateNotifierProvider.autoDispose<HomeController, HomeState>((ref) {
  return HomeController(ref.watch(dashboardRepositoryProvider));
});
