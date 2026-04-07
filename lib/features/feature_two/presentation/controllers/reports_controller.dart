import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../data/models/report_model.dart';
import '../../data/repositories/reports_repository.dart';

// ─── Reports list (used by FeatureTwoScreen) ───────────────────────

class ReportItem {
  final String id;
  final String disease;
  final String location;
  final int cases;
  final String reporter;
  final String timeAgo;

  const ReportItem({
    required this.id,
    required this.disease,
    required this.location,
    required this.cases,
    required this.reporter,
    required this.timeAgo,
  });
}

final activeFilterChipProvider = StateProvider<String>((ref) => 'All');

final reportsProvider = Provider<List<ReportItem>>((ref) {
  return const [
    ReportItem(id: '1', disease: 'Malaria', location: 'Accra Metro', cases: 5, reporter: 'Dr. Mensah', timeAgo: '1h ago'),
    ReportItem(id: '2', disease: 'Cholera', location: 'Ga West', cases: 12, reporter: 'Nurse Addo', timeAgo: '3h ago'),
    ReportItem(id: '3', disease: 'Dengue', location: 'Tema Metro', cases: 3, reporter: 'Dr. Osei', timeAgo: '6h ago'),
    ReportItem(id: '4', disease: 'COVID-19', location: 'Accra Metro', cases: 2, reporter: 'Dr. Asante', timeAgo: '12h ago'),
    ReportItem(id: '5', disease: 'Malaria', location: 'Kpone Katamanso', cases: 8, reporter: 'Nurse Brew', timeAgo: '1d ago'),
  ];
});

// ─── Reference data item for dropdowns ─────────────────────────────

class ReferenceItem {
  final int id;
  final String name;
  const ReferenceItem({required this.id, required this.name});
}

// ─── Report form state ─────────────────────────────────────────────

class ReportFormState {
  final String? selectedDisease;
  final String? selectedLocation;
  final DateTime? date;
  final TimeOfDay? time;
  final int caseCount;
  final String severity;
  final String reportSource;
  final String notes;

  // IDSR fields
  final String caseClassification;
  final int deathCount;
  final String reportType;
  final String healthFacility;

  // Sex breakdown counts
  final int maleCount;
  final int femaleCount;
  final int unknownSexCount;

  // Age breakdown counts
  final int ageUnder5Count;
  final int age5To17Count;
  final int age18To59Count;
  final int age60PlusCount;
  final int unknownAgeCount;

  final bool isLoadingData;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;
  final bool isDraftSaved;

  final List<ReferenceItem> diseases;
  final List<ReferenceItem> locations;
  final int? currentUserId;
  final int? submittedStatusId;
  final int? draftStatusId;
  final int? editingReportId;

  bool get isEditMode => editingReportId != null;

  int get sexTotal => maleCount + femaleCount + unknownSexCount;
  int get ageTotal => ageUnder5Count + age5To17Count + age18To59Count + age60PlusCount + unknownAgeCount;

  const ReportFormState({
    this.selectedDisease,
    this.selectedLocation,
    this.date,
    this.time,
    this.caseCount = 1,
    this.severity = 'Unknown',
    this.reportSource = 'Facility',
    this.notes = '',
    this.caseClassification = 'Unknown',
    this.deathCount = 0,
    this.reportType = 'Weekly',
    this.healthFacility = '',
    this.maleCount = 0,
    this.femaleCount = 0,
    this.unknownSexCount = 0,
    this.ageUnder5Count = 0,
    this.age5To17Count = 0,
    this.age18To59Count = 0,
    this.age60PlusCount = 0,
    this.unknownAgeCount = 0,
    this.isLoadingData = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
    this.isDraftSaved = false,
    this.diseases = const [],
    this.locations = const [],
    this.currentUserId,
    this.submittedStatusId,
    this.draftStatusId,
    this.editingReportId,
  });

  ReportFormState copyWith({
    String? selectedDisease,
    String? selectedLocation,
    DateTime? date,
    TimeOfDay? time,
    int? caseCount,
    String? severity,
    String? reportSource,
    String? notes,
    String? caseClassification,
    int? deathCount,
    String? reportType,
    String? healthFacility,
    int? maleCount,
    int? femaleCount,
    int? unknownSexCount,
    int? ageUnder5Count,
    int? age5To17Count,
    int? age18To59Count,
    int? age60PlusCount,
    int? unknownAgeCount,
    bool? isLoadingData,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
    bool? isDraftSaved,
    List<ReferenceItem>? diseases,
    List<ReferenceItem>? locations,
    int? currentUserId,
    int? submittedStatusId,
    int? draftStatusId,
    int? editingReportId,
  }) {
    return ReportFormState(
      selectedDisease: selectedDisease ?? this.selectedDisease,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      date: date ?? this.date,
      time: time ?? this.time,
      caseCount: caseCount ?? this.caseCount,
      severity: severity ?? this.severity,
      reportSource: reportSource ?? this.reportSource,
      notes: notes ?? this.notes,
      caseClassification: caseClassification ?? this.caseClassification,
      deathCount: deathCount ?? this.deathCount,
      reportType: reportType ?? this.reportType,
      healthFacility: healthFacility ?? this.healthFacility,
      maleCount: maleCount ?? this.maleCount,
      femaleCount: femaleCount ?? this.femaleCount,
      unknownSexCount: unknownSexCount ?? this.unknownSexCount,
      ageUnder5Count: ageUnder5Count ?? this.ageUnder5Count,
      age5To17Count: age5To17Count ?? this.age5To17Count,
      age18To59Count: age18To59Count ?? this.age18To59Count,
      age60PlusCount: age60PlusCount ?? this.age60PlusCount,
      unknownAgeCount: unknownAgeCount ?? this.unknownAgeCount,
      isLoadingData: isLoadingData ?? this.isLoadingData,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      diseases: diseases ?? this.diseases,
      locations: locations ?? this.locations,
      currentUserId: currentUserId ?? this.currentUserId,
      submittedStatusId: submittedStatusId ?? this.submittedStatusId,
      draftStatusId: draftStatusId ?? this.draftStatusId,
      editingReportId: editingReportId ?? this.editingReportId,
    );
  }
}

// ─── Report form controller ────────────────────────────────────────

class ReportFormController extends StateNotifier<ReportFormState> {
  final ReportsRepository _reportsRepo;
  final AuthRepository _authRepo;
  final int? editReportId;

  ReportFormController(this._reportsRepo, this._authRepo, {this.editReportId})
      : super(const ReportFormState()) {
    loadReferenceData();
  }

  Future<void> loadReferenceData() async {
    state = state.copyWith(isLoadingData: true, errorMessage: null);
    try {
      final results = await Future.wait([
        _reportsRepo.getDiseases(),
        _reportsRepo.getLocations(),
        _reportsRepo.getStatuses(),
        _authRepo.fetchCurrentUser(),
      ]);

      final diseasesRaw = results[0] as List<Map<String, dynamic>>;
      final locationsRaw = results[1] as List<Map<String, dynamic>>;
      final statusesRaw = results[2] as List<Map<String, dynamic>>;
      final user = results[3];

      final diseases = diseasesRaw
          .map((d) => ReferenceItem(
                id: d['id'] as int,
                name: d['disease_name'] as String,
              ))
          .toList();

      final locations = locationsRaw
          .map((l) => ReferenceItem(
                id: l['id'] as int,
                name: l['district_name'] as String,
              ))
          .toList();

      int? submittedId;
      int? draftId;
      for (final s in statusesRaw) {
        final name = s['status_name'] as String;
        if (name == 'SUBMITTED') submittedId = s['id'] as int;
        if (name == 'DRAFT') draftId = s['id'] as int;
      }

      if (submittedId == null) {
        final created = await _reportsRepo.createStatus(
          'SUBMITTED',
          'Report submitted by health worker and ready for review.',
        );
        submittedId = created['id'] as int;
      }
      if (draftId == null) {
        final created = await _reportsRepo.createStatus(
          'DRAFT',
          'Report saved as draft. Can be edited and submitted later.',
        );
        draftId = created['id'] as int;
      }

      debugPrint('Resolved user: id=${(user as dynamic).id}, name=${(user as dynamic).name}');

      state = state.copyWith(
        diseases: diseases,
        locations: locations,
        currentUserId: (user as dynamic).id as int,
        submittedStatusId: submittedId,
        draftStatusId: draftId,
      );

      if (editReportId != null) {
        await _loadExistingReport(editReportId!, diseases, locations);
      } else {
        state = state.copyWith(isLoadingData: false);
      }
    } on ApiException catch (e) {
      state = state.copyWith(isLoadingData: false, errorMessage: e.message);
    } catch (e) {
      debugPrint('loadReferenceData error: $e');
      state = state.copyWith(
        isLoadingData: false,
        errorMessage: 'Failed to load form data. Check your connection.',
      );
    }
  }

  Future<void> _loadExistingReport(
    int reportId,
    List<ReferenceItem> diseases,
    List<ReferenceItem> locations,
  ) async {
    try {
      final report = await _reportsRepo.getReport(reportId);

      final diseaseName =
          diseases.where((d) => d.id == report.disease).firstOrNull?.name;
      final locationName =
          locations.where((l) => l.id == report.location).firstOrNull?.name;

      DateTime? date;
      TimeOfDay? time;
      if (report.observedAt != null) {
        final dt = DateTime.tryParse(report.observedAt!);
        if (dt != null) {
          date = DateTime(dt.year, dt.month, dt.day);
          time = TimeOfDay(hour: dt.hour, minute: dt.minute);
        }
      }

      state = state.copyWith(
        isLoadingData: false,
        editingReportId: reportId,
        selectedDisease: diseaseName,
        selectedLocation: locationName,
        date: date,
        time: time,
        caseCount: report.caseCount,
        severity: AppConstants.severityDisplayLabels[report.severityLevel] ?? 'Unknown',
        reportSource: AppConstants.reportSourceDisplayLabels[report.reportSource] ?? 'Facility',
        notes: report.caseNotes ?? '',
        caseClassification: AppConstants.caseClassificationDisplayLabels[report.caseClassification] ?? 'Unknown',
        deathCount: report.deathCount,
        reportType: AppConstants.reportTypeDisplayLabels[report.reportType] ?? 'Weekly',
        healthFacility: report.healthFacility ?? '',
        maleCount: report.maleCount,
        femaleCount: report.femaleCount,
        unknownSexCount: report.unknownSexCount,
        ageUnder5Count: report.ageUnder5Count,
        age5To17Count: report.age5To17Count,
        age18To59Count: report.age18To59Count,
        age60PlusCount: report.age60PlusCount,
        unknownAgeCount: report.unknownAgeCount,
      );
    } catch (e) {
      debugPrint('_loadExistingReport error: $e');
      state = state.copyWith(
        isLoadingData: false,
        errorMessage: 'Failed to load draft report.',
      );
    }
  }

  void setDisease(String v) => state = state.copyWith(selectedDisease: v);
  void setLocation(String v) => state = state.copyWith(selectedLocation: v);
  void setDate(DateTime v) => state = state.copyWith(date: v);
  void setTime(TimeOfDay v) => state = state.copyWith(time: v);
  void setCaseCount(int v) => state = state.copyWith(caseCount: v < 1 ? 1 : v);
  void setSeverity(String v) => state = state.copyWith(severity: v);
  void setSource(String v) => state = state.copyWith(reportSource: v);
  void setNotes(String v) => state = state.copyWith(notes: v);
  void setCaseClassification(String v) => state = state.copyWith(caseClassification: v);
  void setDeathCount(int v) => state = state.copyWith(deathCount: v < 0 ? 0 : v);
  void setReportType(String v) => state = state.copyWith(reportType: v);
  void setHealthFacility(String v) => state = state.copyWith(healthFacility: v);
  void setMaleCount(int v) => state = state.copyWith(maleCount: v < 0 ? 0 : v);
  void setFemaleCount(int v) => state = state.copyWith(femaleCount: v < 0 ? 0 : v);
  void setUnknownSexCount(int v) => state = state.copyWith(unknownSexCount: v < 0 ? 0 : v);
  void setAgeUnder5Count(int v) => state = state.copyWith(ageUnder5Count: v < 0 ? 0 : v);
  void setAge5To17Count(int v) => state = state.copyWith(age5To17Count: v < 0 ? 0 : v);
  void setAge18To59Count(int v) => state = state.copyWith(age18To59Count: v < 0 ? 0 : v);
  void setAge60PlusCount(int v) => state = state.copyWith(age60PlusCount: v < 0 ? 0 : v);
  void setUnknownAgeCount(int v) => state = state.copyWith(unknownAgeCount: v < 0 ? 0 : v);

  String? validate() {
    if (state.selectedDisease == null) return 'Please select a disease.';
    if (state.selectedLocation == null) return 'Please select a location.';
    if (state.date == null) return 'Please select a date.';
    if (state.caseCount < 1) return 'Case count must be at least 1.';
    if (state.deathCount > state.caseCount) {
      return 'Deaths (${state.deathCount}) cannot exceed case count (${state.caseCount}).';
    }
    final sexTotal = state.sexTotal;
    if (sexTotal > 0 && sexTotal != state.caseCount) {
      return 'Sex breakdown total ($sexTotal) must equal case count (${state.caseCount}).';
    }
    final ageTotal = state.ageTotal;
    if (ageTotal > 0 && ageTotal != state.caseCount) {
      return 'Age breakdown total ($ageTotal) must equal case count (${state.caseCount}).';
    }
    return null;
  }

  Future<bool> submit() => _save(asDraft: false);

  Future<bool> saveAsDraft() => _save(asDraft: true);

  Future<bool> _save({required bool asDraft}) async {
    final error = validate();
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return false;
    }

    if (state.currentUserId == null || state.currentUserId == 0) {
      debugPrint('reported_by resolution failed: currentUserId=${state.currentUserId}');
      state = state.copyWith(
        errorMessage: 'Unable to identify reporting user. Please log in again.',
      );
      return false;
    }

    final statusId = asDraft ? state.draftStatusId : state.submittedStatusId;
    if (statusId == null) {
      state = state.copyWith(
        errorMessage: 'Form data not loaded. Please wait or tap retry.',
      );
      return false;
    }

    final diseaseId = state.diseases
        .where((d) => d.name == state.selectedDisease)
        .firstOrNull
        ?.id;
    final locationId = state.locations
        .where((l) => l.name == state.selectedLocation)
        .firstOrNull
        ?.id;

    if (diseaseId == null || locationId == null) {
      state = state.copyWith(errorMessage: 'Invalid disease or location.');
      return false;
    }

    final date = state.date!;
    final time = state.time;
    final observedAt = DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 0,
      time?.minute ?? 0,
    );
    final observedAtStr = observedAt.toIso8601String();
    final observedAtFormatted = observedAtStr.length >= 19
        ? observedAtStr.substring(0, 19)
        : observedAtStr;

    final severityValue = AppConstants.severityApiValues[state.severity] ?? 'UNKNOWN';
    final sourceValue = AppConstants.reportSourceApiValues[state.reportSource] ?? state.reportSource;
    final notesValue = state.notes.isEmpty ? null : state.notes;
    final classificationValue = AppConstants.caseClassificationApiValues[state.caseClassification] ?? 'UNKNOWN';
    final reportTypeValue = AppConstants.reportTypeApiValues[state.reportType] ?? 'WEEKLY';
    final healthFacilityValue = state.healthFacility.trim();

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final payload = <String, dynamic>{
        'disease': diseaseId,
        'location': locationId,
        'reported_by': state.currentUserId,
        'status': statusId,
        'observed_at': observedAtFormatted,
        'case_count': state.caseCount,
        'death_count': state.deathCount,
        'case_classification': classificationValue,
        'report_type': reportTypeValue,
        'male_count': state.maleCount,
        'female_count': state.femaleCount,
        'unknown_sex_count': state.unknownSexCount,
        'age_under5_count': state.ageUnder5Count,
        'age_5_17_count': state.age5To17Count,
        'age_18_59_count': state.age18To59Count,
        'age_60plus_count': state.age60PlusCount,
        'unknown_age_count': state.unknownAgeCount,
        'severity_level': severityValue,
        'report_source': sourceValue,
        if (healthFacilityValue.isNotEmpty) 'health_facility': healthFacilityValue,
        'case_notes': notesValue,
      };

      if (state.editingReportId != null) {
        debugPrint('Report update payload (id=${state.editingReportId}): $payload');
        await _reportsRepo.updateReport(state.editingReportId!, payload);
      } else {
        debugPrint('Report create payload: $payload');
        final report = ReportModel(
          disease: diseaseId,
          location: locationId,
          reportedBy: state.currentUserId,
          status: statusId,
          observedAt: observedAtFormatted,
          caseCount: state.caseCount,
          deathCount: state.deathCount,
          caseClassification: classificationValue,
          reportType: reportTypeValue,
          healthFacility: healthFacilityValue.isNotEmpty ? healthFacilityValue : null,
          maleCount: state.maleCount,
          femaleCount: state.femaleCount,
          unknownSexCount: state.unknownSexCount,
          ageUnder5Count: state.ageUnder5Count,
          age5To17Count: state.age5To17Count,
          age18To59Count: state.age18To59Count,
          age60PlusCount: state.age60PlusCount,
          unknownAgeCount: state.unknownAgeCount,
          severityLevel: severityValue,
          reportSource: sourceValue,
          caseNotes: notesValue,
        );
        await _reportsRepo.createReport(report);
      }

      state = state.copyWith(
        isSubmitting: false,
        isSuccess: !asDraft,
        isDraftSaved: asDraft,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Operation failed. Please try again.',
      );
      return false;
    }
  }

  void resetForm() {
    state = ReportFormState(
      diseases: state.diseases,
      locations: state.locations,
      currentUserId: state.currentUserId,
      submittedStatusId: state.submittedStatusId,
      draftStatusId: state.draftStatusId,
    );
  }
}

final reportFormProvider = StateNotifierProvider.autoDispose
    .family<ReportFormController, ReportFormState, int?>((ref, editReportId) {
  return ReportFormController(
    ref.watch(reportsRepositoryProvider),
    ref.watch(authRepositoryProvider),
    editReportId: editReportId,
  );
});
