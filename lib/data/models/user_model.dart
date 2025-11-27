class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final double? cgpa;
  final String? branch;
  final String? resumeUrl;
  final String? company;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.cgpa,
    this.branch,
    this.resumeUrl,
    this.company
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      cgpa: json['cgpa']?.toDouble(),
      branch: json['branch'],
      resumeUrl: json['resumeUrl'],
      company: json['company']
    );
  }
}
