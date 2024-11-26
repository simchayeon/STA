class MypageModel {
  final String name;
  final String major;
  final String id;
  final String email;
  String grade;
  final String std_id;
  String semester;

  MypageModel({
    required this.name,
    required this.major,
    required this.id,
    required this.email,
    required this.grade,
    required this.std_id,
    required this.semester,
  });

  factory MypageModel.fromJson(Map<String, dynamic> json) {
    return MypageModel(
      name: json['name'],
      major: json['major'],
      id: json['id'],
      email: json['email'],
      std_id: json['std_id'],
      grade: json['grade'],
      semester: json['semester'],
    );
  }
}
