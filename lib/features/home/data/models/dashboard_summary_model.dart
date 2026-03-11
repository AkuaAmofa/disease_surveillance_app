class DashboardSummary {
  final int cases7d;
  final int cases30d;
  final int reports7d;
  final int activeAlerts;

  const DashboardSummary({
    this.cases7d = 0,
    this.cases30d = 0,
    this.reports7d = 0,
    this.activeAlerts = 0,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      cases7d: (json['cases_7d'] as num?)?.toInt() ?? 0,
      cases30d: (json['cases_30d'] as num?)?.toInt() ?? 0,
      reports7d: (json['reports_7d'] as num?)?.toInt() ?? 0,
      activeAlerts: (json['active_alerts'] as num?)?.toInt() ?? 0,
    );
  }

  static const mock = DashboardSummary(
    cases7d: 142,
    cases30d: 589,
    reports7d: 38,
    activeAlerts: 7,
  );
}

class RecentAlert {
  final int id;
  final String diseaseName;
  final String locationName;
  final String severity;
  final String createdAt;

  const RecentAlert({
    required this.id,
    required this.diseaseName,
    required this.locationName,
    required this.severity,
    required this.createdAt,
  });

  factory RecentAlert.fromJson(Map<String, dynamic> json) {
    return RecentAlert(
      id: json['id'] as int? ?? 0,
      diseaseName: json['disease_name'] as String? ?? 'Unknown',
      locationName: json['location_name'] as String? ?? 'Unknown',
      severity: json['severity_level'] as String? ?? 'medium',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
