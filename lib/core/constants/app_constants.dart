abstract final class AppConstants {
  static const String appName = 'Disease Surveillance';
  static const String appSubtitle = 'Ghana Health Service';
  static const String appVersion = 'v2.0';

  static const String apiBaseUrl = 'https://disease-surveillance-dashboard-eah8.onrender.com';
  static const String apiBaseUrlIos = 'https://disease-surveillance-dashboard-eah8.onrender.com';

  static const String tokenStorageKey = 'auth_token';

  static const List<String> diseases = [
    'Cholera',
    'COVID-19',
    'Diarrhea (Acute Watery)',
    'Influenza-like Illness (ILI)',
    'Malaria',
    'Measles',
    'Meningitis',
    'Tuberculosis',
    'Typhoid Fever',
    'Yellow Fever',
  ];

  static const List<String> locations = [
    'Ablekuma Central Municipal',
    'Ablekuma North Municipal',
    'Ablekuma West Municipal',
    'Accra Metropolitan',
    'Adenta Municipal',
    'Ashaiman Municipal',
    'Ayawaso Central Municipal',
    'Ayawaso East Municipal',
    'Ayawaso North Municipal',
    'Ayawaso West Municipal',
    'Ga East Municipal',
    'Ga South Municipal',
    'Ga West Municipal',
    'Korle-Klottey Municipal',
    'Kpone Katamanso Municipal',
    'La Dade-Kotopon Municipal',
    'Ledzokuku Municipal',
    'Ningo-Prampram District',
    'Okaikwei North Municipal',
    'Shai-Osudoku District',
    'Tema Metropolitan',
    'Weija-Gbawe Municipal',
  ];

  static const List<String> severities = [
    'Mild',
    'Moderate',
    'Severe',
    'Critical',
    'Unknown',
  ];

  static const List<String> reportSources = [
    'Facility',
    'Lab',
    'Community',
    'Other',
  ];

  static const List<String> sexOptions = [
    'Male',
    'Female',
    'Other',
    'Unknown',
  ];

  static const List<String> ageGroups = [
    'Under 5',
    '5-17',
    '18-59',
    '60+',
    'Unknown',
  ];

  static const List<String> caseClassifications = [
    'Suspected',
    'Probable',
    'Confirmed',
    'Unknown',
  ];

  static const List<String> reportTypes = [
    'Weekly',
    'Immediate',
    'Outbreak',
  ];

  static const double bottomNavHeight = 80;

  /// Maps display labels to Django Report model TextChoices values.
  static const Map<String, String> caseClassificationApiValues = {
    'Suspected': 'SUSPECTED',
    'Probable': 'PROBABLE',
    'Confirmed': 'CONFIRMED',
    'Unknown': 'UNKNOWN',
  };

  static const Map<String, String> reportTypeApiValues = {
    'Weekly': 'WEEKLY',
    'Immediate': 'IMMEDIATE',
    'Outbreak': 'OUTBREAK',
  };

  static const Map<String, String> caseClassificationDisplayLabels = {
    'SUSPECTED': 'Suspected',
    'PROBABLE': 'Probable',
    'CONFIRMED': 'Confirmed',
    'UNKNOWN': 'Unknown',
  };

  static const Map<String, String> reportTypeDisplayLabels = {
    'WEEKLY': 'Weekly',
    'IMMEDIATE': 'Immediate',
    'OUTBREAK': 'Outbreak',
  };

  static const Map<String, String> sexApiValues = {
    'Male': 'MALE',
    'Female': 'FEMALE',
    'Other': 'OTHER',
    'Unknown': 'UNKNOWN',
  };

  static const Map<String, String> ageGroupApiValues = {
    'Under 5': 'UNDER_5',
    '5-17': 'AGE_5_17',
    '18-59': 'AGE_18_59',
    '60+': 'AGE_60_PLUS',
    'Unknown': 'UNKNOWN',
  };

  static const Map<String, String> severityApiValues = {
    'Mild': 'MILD',
    'Moderate': 'MODERATE',
    'Severe': 'SEVERE',
    'Critical': 'CRITICAL',
    'Unknown': 'UNKNOWN',
  };

  /// Maps display labels to backend report_source choice values.
  static const Map<String, String> reportSourceApiValues = {
    'Facility': 'FACILITY',
    'Lab': 'LAB',
    'Community': 'COMMUNITY',
    'Other': 'OTHER',
  };

  /// Reverse maps: API choice value → display label.
  static const Map<String, String> sexDisplayLabels = {
    'MALE': 'Male',
    'FEMALE': 'Female',
    'OTHER': 'Other',
    'UNKNOWN': 'Unknown',
  };

  static const Map<String, String> ageGroupDisplayLabels = {
    'UNDER_5': 'Under 5',
    'AGE_5_17': '5-17',
    'AGE_18_59': '18-59',
    'AGE_60_PLUS': '60+',
    'UNKNOWN': 'Unknown',
  };

  static const Map<String, String> severityDisplayLabels = {
    'MILD': 'Mild',
    'MODERATE': 'Moderate',
    'SEVERE': 'Severe',
    'CRITICAL': 'Critical',
    'UNKNOWN': 'Unknown',
  };

  static const Map<String, String> reportSourceDisplayLabels = {
    'FACILITY': 'Facility',
    'LAB': 'Lab',
    'COMMUNITY': 'Community',
    'OTHER': 'Other',
  };
}
