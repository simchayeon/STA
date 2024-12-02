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
    // 강의명에서 강좌번호 추출
    String fullName = json['name'];
    String extractedLectureNumber = _extractLectureNumber(fullName);

    return Subject(
      classTime: json['classTime'],
      name: fullName,
      professor: json['professor'],
      lectureNumber: extractedLectureNumber,
    );
  }

  // 강의명에서 강좌번호 추출하는 헬퍼 메서드
  static String _extractLectureNumber(String fullName) {
    // 정규 표현식을 사용하여 -와 ) 사이의 숫자를 추출
    final regex = RegExp(r'-\d{4}\)'); // - 다음에 4자리 숫자와 )가 오는 패턴
    final match = regex.firstMatch(fullName);

    if (match != null) {
      // -와 ) 사이의 숫자 4개를 반환
      return match.group(0)!.substring(1, 5); // -을 제외한 4자리 숫자
    }
    return ''; // 강좌번호가 없으면 빈 문자열 반환
  }
}
