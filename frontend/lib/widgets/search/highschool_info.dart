class HighSchoolInfo {
  final int id;
  final String name;
  final String prefecture;

  HighSchoolInfo(
      {required this.id, required this.name, required this.prefecture});

  factory HighSchoolInfo.fromJson(Map<String, dynamic> json) {
    return HighSchoolInfo(
      id: json['id'],
      name: json['name'],
      prefecture: json['prefecture'],
    );
  }
}
