// lib/models/major_model.dart
class Major {
  final String name;

  Major({required this.name});

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(name: json['name']);
  }
}
