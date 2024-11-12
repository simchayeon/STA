import 'package:flutter/material.dart';
import 'package:smarttimetable/services/api_service.dart'; // API 서비스 임포트
import 'package:smarttimetable/models/user_model.dart'; // User 모델 임포트
import 'package:smarttimetable/Screens/main_page.dart'; // 메인 페이지 임포트

/// 로그인 관련 로직을 처리하는 컨트롤러 클래스
class LoginController {
  final ApiService _apiService = ApiService(); // API 서비스 인스턴스 생성

  /// 로그인 메소드
  /// [user]는 로그인 시도에 사용할 사용자 정보 (ID 및 비밀번호)
  Future<bool> login(User user) async {
    // API 요청을 통해 로그인 시도
    bool isSuccess = await _apiService.login(user); // API 요청 호출
    return isSuccess; // 성공 여부 반환
  }
}
