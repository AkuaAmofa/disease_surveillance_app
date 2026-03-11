import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../data/models/report_model.dart';
import '../../data/repositories/reports_repository.dart';

final submissionsTabProvider = StateProvider<int>((ref) => 0);

// ─── State ─────────────────────────────────────────────────────────

class MySubmissionsState {
  final bool isLoading;
  final String? errorMessage;
  final List<ReportModel> reports;
  final Map<int, String> diseaseNames;
  final Map<int, String> locationNames;
  final int? draftStatusId;
  final int? submittedStatusId;

  const MySubmissionsState({
    this.isLoading = false,
    this.errorMessage,
    this.reports = const [],
    this.diseaseNames = const {},
    this.locationNames = const {},
    this.draftStatusId,
    this.submittedStatusId,
  });

  List<ReportModel> get drafts =>
      draftStatusId == null ? [] : reports.where((r) => r.status == draftStatusId).toList();

  List<ReportModel> get submitted =>
      submittedStatusId == null ? [] : reports.where((r) => r.status == submittedStatusId).toList();

  String diseaseName(int? id) => diseaseNames[id] ?? '—';
  String locationName(int? id) => locationNames[id] ?? '—';

  String sourceName(String? apiValue) =>
      AppConstants.reportSourceDisplayLabels[apiValue] ?? apiValue ?? '—';

  String formatDate(String? iso) {
    if (iso == null) return '—';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.day} ${_months[dt.month - 1]} ${dt.year}';
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  MySubmissionsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ReportModel>? reports,
    Map<int, String>? diseaseNames,
    Map<int, String>? locationNames,
    int? draftStatusId,
    int? submittedStatusId,
  }) {
    return MySubmissionsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      reports: reports ?? this.reports,
      diseaseNames: diseaseNames ?? this.diseaseNames,
      locationNames: locationNames ?? this.locationNames,
      draftStatusId: draftStatusId ?? this.draftStatusId,
      submittedStatusId: submittedStatusId ?? this.submittedStatusId,
    );
  }
}

// ─── Controller ────────────────────────────────────────────────────

class MySubmissionsController extends StateNotifier<MySubmissionsState> {
  final ReportsRepository _reportsRepo;
  final AuthRepository _authRepo;

  MySubmissionsController(this._reportsRepo, this._authRepo)
      : super(const MySubmissionsState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await Future.wait([
        _authRepo.fetchCurrentUser(),
        _reportsRepo.getStatuses(),
        _reportsRepo.getDiseases(),
        _reportsRepo.getLocations(),
      ]);

      final user = results[0];
      final statusesRaw = results[1] as List<Map<String, dynamic>>;
      final diseasesRaw = results[2] as List<Map<String, dynamic>>;
      final locationsRaw = results[3] as List<Map<String, dynamic>>;

      int? draftId, submittedId;
      for (final s in statusesRaw) {
        final name = s['status_name'] as String;
        if (name == 'DRAFT') draftId = s['id'] as int;
        if (name == 'SUBMITTED') submittedId = s['id'] as int;
      }

      final diseaseNames = {
        for (final d in diseasesRaw) d['id'] as int: d['disease_name'] as String,
      };
      final locationNames = {
        for (final l in locationsRaw) l['id'] as int: l['district_name'] as String,
      };

      final userId = (user as dynamic).id as int;
      debugPrint('MySubmissions: fetching reports for user $userId');
      final reports = await _reportsRepo.getReports(reportedBy: userId);

      state = MySubmissionsState(
        reports: reports,
        diseaseNames: diseaseNames,
        locationNames: locationNames,
        draftStatusId: draftId,
        submittedStatusId: submittedId,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      debugPrint('MySubmissions load error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load submissions.',
      );
    }
  }

  Future<void> refresh() => load();
}

final mySubmissionsProvider =
    StateNotifierProvider.autoDispose<MySubmissionsController, MySubmissionsState>(
        (ref) {
  return MySubmissionsController(
    ref.watch(reportsRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
});
