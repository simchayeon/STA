class AddMajor {
  String classTime; // 강의 시간
  String name; // 강의 이름 및 코드
  String professor; // 교수 이름
  String lectureNumber; // 강의 번호

  AddMajor({
    required this.classTime,
    required this.name,
    required this.professor,
    required this.lectureNumber,
  });

  // Map 데이터를 객체로 변환하는 factory 생성자
  factory AddMajor.fromMap(Map<String, dynamic> map) {
    return AddMajor(
      classTime: map['classTime'] ?? '',
      name: map['name'] ?? '',
      professor: map['professor'] ?? '',
      lectureNumber: map['lectureNumber'] ?? '',
    );
  }

  // 객체를 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'classTime': classTime,
      'name': name,
      'professor': professor,
      'lectureNumber': lectureNumber,
    };
  }

  // JSON 데이터 리스트를 객체 리스트로 변환하는 static 메서드
  static List<AddMajor> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AddMajor.fromMap(json)).toList();
  }

  @override
  String toString() {
    return 'AddMajor(classTime: $classTime, name: $name, professor: $professor, lectureNumber: $lectureNumber)';
  }
}
