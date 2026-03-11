import '../../../../core/network/api_client.dart';
import '../models/dashboard_summary_model.dart';

class DashboardRemoteSource {
  final ApiClient _client;

  DashboardRemoteSource(this._client);

  Future<DashboardSummary> fetchSummary() async {
    final response = await _client.get('/api/v1/dashboard/summary/');
    return DashboardSummary.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<RecentAlert>> fetchRecentAlerts({int limit = 5}) async {
    final response = await _client.get(
      '/api/v1/dashboard/recent-alerts/',
      queryParameters: {'limit': limit},
    );
    final list = response.data as List<dynamic>? ?? [];
    return list
        .map((e) => RecentAlert.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> fetchSituationOverview() async {
    final response = await _client.get('/api/v1/dashboard/situation-overview/');
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchDataQuality() async {
    final response = await _client.get('/api/v1/dashboard/data-quality/');
    return response.data as Map<String, dynamic>;
  }
}
