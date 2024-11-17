// lib/models/elective_course_model.dart
class ElectiveCourse {
  final String name;

  ElectiveCourse({required this.name});

  factory ElectiveCourse.fromJson(Map<String, dynamic> json) {
    return ElectiveCourse(name: json['name']); // JSON에서 'name' 필드 가져오기
  }
}
