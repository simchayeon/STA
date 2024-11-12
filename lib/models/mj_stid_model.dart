// lib/models/major_info_model.dart

/// 전공 및 학번 정보, 아이디를 저장하는 모델 클래스
class MajorInfo {
  final String id;
  final String major; // 학과
  final String student_id; // 학번

  MajorInfo({
    required this.id,
    required this.major,
    required this.student_id,
  });
}
