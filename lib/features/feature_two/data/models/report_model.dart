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
  final String? severityLevel;

  // IDSR classification fields (new)
  final String? caseClassification; // SUSPECTED, PROBABLE, CONFIRMED, UNKNOWN
  final int deathCount;
  final String? reportType; // IMMEDIATE, WEEKLY, OUTBREAK
  final String? healthFacility;

  // Sex breakdown counts (replace old sex enum)
  final int maleCount;
  final int femaleCount;
  final int unknownSexCount;

  // Age breakdown counts (replace old age_group enum)
  final int ageUnder5Count;
  final int age5To17Count;
  final int age18To59Count;
  final int age60PlusCount;
  final int unknownAgeCount;

  // Legacy fields — kept for fromJson compatibility only; do NOT send in toJson.
  final String? sex;
  final String? ageGroup;

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
    this.severityLevel,
    this.caseClassification,
    this.deathCount = 0,
    this.reportType,
    this.healthFacility,
    this.maleCount = 0,
    this.femaleCount = 0,
    this.unknownSexCount = 0,
    this.ageUnder5Count = 0,
    this.age5To17Count = 0,
    this.age18To59Count = 0,
    this.age60PlusCount = 0,
    this.unknownAgeCount = 0,
    this.sex,
    this.ageGroup,
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
      severityLevel: json['severity_level'] as String?,
      caseClassification: json['case_classification'] as String?,
      deathCount: (json['death_count'] as num?)?.toInt() ?? 0,
      reportType: json['report_type'] as String?,
      healthFacility: json['health_facility'] as String?,
      maleCount: (json['male_count'] as num?)?.toInt() ?? 0,
      femaleCount: (json['female_count'] as num?)?.toInt() ?? 0,
      unknownSexCount: (json['unknown_sex_count'] as num?)?.toInt() ?? 0,
      ageUnder5Count: (json['age_under5_count'] as num?)?.toInt() ?? 0,
      age5To17Count: (json['age_5_17_count'] as num?)?.toInt() ?? 0,
      age18To59Count: (json['age_18_59_count'] as num?)?.toInt() ?? 0,
      age60PlusCount: (json['age_60plus_count'] as num?)?.toInt() ?? 0,
      unknownAgeCount: (json['unknown_age_count'] as num?)?.toInt() ?? 0,
      // Legacy fields
      sex: json['sex'] as String?,
      ageGroup: json['age_group'] as String?,
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
      if (severityLevel != null) 'severity_level': severityLevel,
      if (caseClassification != null) 'case_classification': caseClassification,
      'death_count': deathCount,
      if (reportType != null) 'report_type': reportType,
      if (healthFacility != null && healthFacility!.isNotEmpty) 'health_facility': healthFacility,
      'male_count': maleCount,
      'female_count': femaleCount,
      'unknown_sex_count': unknownSexCount,
      'age_under5_count': ageUnder5Count,
      'age_5_17_count': age5To17Count,
      'age_18_59_count': age18To59Count,
      'age_60plus_count': age60PlusCount,
      'unknown_age_count': unknownAgeCount,
    };
  }
}
