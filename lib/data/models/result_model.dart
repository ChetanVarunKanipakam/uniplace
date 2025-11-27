class Result {
  final String companyId;
  final List<Map<String, dynamic>> selectedStudents;

  Result({required this.companyId, required this.selectedStudents});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      companyId: json['companyId'],
      selectedStudents: List<Map<String, dynamic>>.from(json['selectedStudents']),
    );
  }
}
