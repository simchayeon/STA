class Subject {
  final String classTime; // 요일 및 강의 시간
  final String name; // 강의명
  final String professor; // 교수명
  final String lectureNumber; // 강좌번호

  Subject({
    required this.classTime,
    required this.name,
    required this.professor,
    required this.lectureNumber,
  });

  // JSON 파싱
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      classTime: json['classTime'],
      name: json['name'],
      professor: json['professor'],
      lectureNumber: json['lectureNumber'],
    );
  }
}
