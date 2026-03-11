import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../models/report_model.dart';

class ReportsRemoteSource {
  final ApiClient _client;

  ReportsRemoteSource(this._client);

  Future<List<ReportModel>> fetchReports({
    int? diseaseId,
    int? locationId,
    int? statusId,
    int? reportedBy,
  }) async {
    final params = <String, dynamic>{};
    if (diseaseId != null) params['disease'] = diseaseId;
    if (locationId != null) params['location'] = locationId;
    if (statusId != null) params['status'] = statusId;
    if (reportedBy != null) params['reported_by'] = reportedBy;
    final response = await _client.get('/api/v1/reporting/reports/', queryParameters: params);
    final list = response.data as List<dynamic>? ?? [];
    return list.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ReportModel> fetchReport(int id) async {
    final response = await _client.get('/api/v1/reporting/reports/$id/');
    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ReportModel> createReport(ReportModel report) async {
    final payload = report.toJson();
    debugPrint('Report create payload: $payload');
    final response = await _client.post('/api/v1/reporting/reports/', data: payload);
    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ReportModel> updateReport(int id, Map<String, dynamic> data) async {
    final response = await _client.patch('/api/v1/reporting/reports/$id/', data: data);
    return ReportModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> fetchDiseases() async {
    final response = await _client.get('/api/v1/diseases/');
    final list = response.data as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchLocations() async {
    final response = await _client.get('/api/v1/locations/');
    final list = response.data as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchStatuses() async {
    final response = await _client.get('/api/v1/reporting/statuses/');
    final list = response.data as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createStatus(String name, String description) async {
    final response = await _client.post(
      '/api/v1/reporting/statuses/',
      data: {'status_name': name, 'description': description},
    );
    return response.data as Map<String, dynamic>;
  }
}
