import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../models/report_model.dart';
import '../sources/reports_remote_source.dart';

final reportsRemoteSourceProvider = Provider<ReportsRemoteSource>((ref) {
  return ReportsRemoteSource(ref.watch(apiClientProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.watch(reportsRemoteSourceProvider));
});

class ReportsRepository {
  final ReportsRemoteSource _source;

  ReportsRepository(this._source);

  Future<List<ReportModel>> getReports({
    int? diseaseId,
    int? locationId,
    int? statusId,
    int? reportedBy,
  }) =>
      _source.fetchReports(
        diseaseId: diseaseId,
        locationId: locationId,
        statusId: statusId,
        reportedBy: reportedBy,
      );

  Future<ReportModel> getReport(int id) => _source.fetchReport(id);

  Future<ReportModel> createReport(ReportModel report) =>
      _source.createReport(report);

  Future<ReportModel> updateReport(int id, Map<String, dynamic> data) =>
      _source.updateReport(id, data);

  Future<List<Map<String, dynamic>>> getDiseases() => _source.fetchDiseases();

  Future<List<Map<String, dynamic>>> getLocations() => _source.fetchLocations();

  Future<List<Map<String, dynamic>>> getStatuses() => _source.fetchStatuses();

  Future<Map<String, dynamic>> createStatus(String name, String description) =>
      _source.createStatus(name, description);
}
