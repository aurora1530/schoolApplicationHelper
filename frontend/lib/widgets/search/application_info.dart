class ApplicationInfo {
  final int id;
  final DateTime deadline;
  final String highSchoolName;
  final String method;
  final List<String> subjects;
  final List<String> documents;

  ApplicationInfo({
    required this.id,
    required this.deadline,
    required this.highSchoolName,
    required this.method,
    required this.subjects,
    required this.documents,
  });

  factory ApplicationInfo.fromJson(Map<String, dynamic> json) {
    return ApplicationInfo(
      id: json['id'],
      deadline: DateTime.parse(json['deadline'].toString()),
      highSchoolName: json['highSchoolName'],
      method: json['method'],
      subjects: json['subjects'].toString().split(','),
      documents: json['documents'].toString().split(','),
    );
  }
}
