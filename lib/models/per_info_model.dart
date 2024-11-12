// lib/models/signup_model.dart

/// 회원가입 정보를 저장하는 모델 클래스
class SignUp {
  final String password; // 사용자 비밀번호
  final String email;
  final String name; // 사용자 이름

  // 생성자: 모든 필수 정보를 받음
  SignUp({
    required this.password,
    required this.email,
    required this.name,
  });
}
