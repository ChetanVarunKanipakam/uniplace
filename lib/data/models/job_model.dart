class Job {
  final String id;
  final String companyId; // references Company
  final String role;
  final String package;
  final Eligibility eligibility;
  final DateTime? deadline;
  final String description;
  final List<String> skillsRequired;

  Job({
    required this.id,
    required this.companyId,
    required this.role,
    required this.package,
    required this.eligibility,
    this.deadline,
    required this.description,
    required this.skillsRequired,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      companyId: json['companyId'] is Map
          ? json['companyId']['_id'] // handle populated company object
          : json['companyId'] ?? "",
      role: json['role'] ?? "",
      package: json['package'] ?? "",
      eligibility: Eligibility.fromJson(json['eligibility'] ?? {}),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      description: json['description'] ?? "",
      skillsRequired: List<String>.from(json['skillsRequired'] ?? []),
    );
  }
}

class Eligibility {
  final double cgpa;
  final List<String> branches;

  Eligibility({
    required this.cgpa,
    required this.branches,
  });

  factory Eligibility.fromJson(Map<String, dynamic> json) {
    return Eligibility(
      cgpa: (json['cgpa'] ?? 0).toDouble(),
      branches: List<String>.from(json['branches'] ?? []),
    );
  }
}
