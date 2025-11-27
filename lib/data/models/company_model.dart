class Company {
  final String id;
  final String name;
  final String photoUrl;
  final String description;

  Company({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.description,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["_id"],
      name: json["name"] ?? "",
      photoUrl: json["photoUrl"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
