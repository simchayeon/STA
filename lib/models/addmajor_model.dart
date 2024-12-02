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
    return jsonList.map((json) => AddMajor.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'AddMajor(classTime: $classTime, name: $name, professor: $professor, lectureNumber: $lectureNumber)';
  }

  // JSON 데이터를 AddMajor 객체로 변환하는 메서드
  factory AddMajor.fromJson(Map<String, dynamic> json) {
    String fullName = json['name'] as String;
    String extractedLectureNumber = _extractLectureNumber(fullName); // 강좌번호 추출

    return AddMajor(
      name: fullName,
      classTime: json['classTime'] as String,
      professor: json['professor'] as String,
      lectureNumber: extractedLectureNumber,
    );
  }

  // 강의명에서 강좌번호 추출하는 헬퍼 메서드
  static String _extractLectureNumber(String fullName) {
    final regex = RegExp(r'-\d{4}\)'); // - 다음에 4자리 숫자와 )가 오는 패턴
    final match = regex.firstMatch(fullName);

    if (match != null) {
      return match.group(0)!.substring(1, 5); // -을 제외한 4자리 숫자
    }
    return ''; // 강좌번호가 없으면 빈 문자열 반환
  }
}
