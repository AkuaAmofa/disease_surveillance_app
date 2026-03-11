import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../models/dashboard_summary_model.dart';
import '../sources/dashboard_remote_source.dart';

final dashboardRemoteSourceProvider = Provider<DashboardRemoteSource>((ref) {
  return DashboardRemoteSource(ref.watch(apiClientProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dashboardRemoteSourceProvider));
});

class DashboardRepository {
  final DashboardRemoteSource _source;

  DashboardRepository(this._source);

  Future<DashboardSummary> getSummary() => _source.fetchSummary();

  Future<List<RecentAlert>> getRecentAlerts({int limit = 5}) =>
      _source.fetchRecentAlerts(limit: limit);

  Future<Map<String, dynamic>> getSituationOverview() =>
      _source.fetchSituationOverview();

  Future<Map<String, dynamic>> getDataQuality() =>
      _source.fetchDataQuality();
}
