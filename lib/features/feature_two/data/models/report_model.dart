class ReportModel {
  final int? id;
  final int? disease;
  final int? location;
  final int? reportedBy;
  final int? status;
  final String? observedAt;
  final String? submittedAt;
  final String? caseNotes;
  final String? reportSource;
  final int caseCount;
  final String? sex;
  final String? ageGroup;
  final String? severityLevel;

  // Resolved display names (populated locally from reference data).
  final String diseaseName;
  final String locationName;
  final String reporterName;

  const ReportModel({
    this.id,
    this.disease,
    this.location,
    this.reportedBy,
    this.status,
    this.observedAt,
    this.submittedAt,
    this.caseNotes,
    this.reportSource,
    this.caseCount = 1,
    this.sex,
    this.ageGroup,
    this.severityLevel,
    this.diseaseName = '',
    this.locationName = '',
    this.reporterName = '',
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int?,
      disease: json['disease'] as int?,
      location: json['location'] as int?,
      reportedBy: json['reported_by'] as int?,
      status: json['status'] as int?,
      observedAt: json['observed_at'] as String?,
      submittedAt: json['submitted_at'] as String?,
      caseNotes: json['case_notes'] as String?,
      reportSource: json['report_source'] as String?,
      caseCount: (json['case_count'] as num?)?.toInt() ?? 1,
      sex: json['sex'] as String?,
      ageGroup: json['age_group'] as String?,
      severityLevel: json['severity_level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (disease != null) 'disease': disease,
      if (location != null) 'location': location,
      if (reportedBy != null) 'reported_by': reportedBy,
      if (status != null) 'status': status,
      if (observedAt != null) 'observed_at': observedAt,
      if (caseNotes != null) 'case_notes': caseNotes,
      if (reportSource != null) 'report_source': reportSource,
      'case_count': caseCount,
      if (sex != null) 'sex': sex,
      if (ageGroup != null) 'age_group': ageGroup,
      if (severityLevel != null) 'severity_level': severityLevel,
    };
  }
}
