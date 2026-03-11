enum SubmissionStatus { draft, submitted }

class SubmissionModel {
  final String id;
  final String disease;
  final String location;
  final int cases;
  final String observedDate;
  final String? submittedDate;
  final String source;
  final SubmissionStatus status;

  const SubmissionModel({
    required this.id,
    required this.disease,
    required this.location,
    required this.cases,
    required this.observedDate,
    this.submittedDate,
    required this.source,
    required this.status,
  });
}
