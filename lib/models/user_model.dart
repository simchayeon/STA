// lib/models/user_model.dart

/// 사용자 정보를 저장하는 모델 클래스
class User {
  String id; // 사용자 ID
  String password; // 사용자 비밀번호

  // 생성자: 사용자 ID와 비밀번호를 필수로 받음
  User({required this.id, required this.password});
}
