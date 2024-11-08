// lib/controllers/login_controller.dart

import 'package:flutter/material.dart';
import 'package:smarttimetable/services/api_service.dart'; // API 서비스 임포트
import 'package:smarttimetable/models/user_model.dart'; // User 모델 임포트
import 'package:smarttimetable/Screens/main_page.dart'; // 메인 페이지 임포트

/// 로그인 관련 로직을 처리하는 컨트롤러 클래스
class LoginController {
  final ApiService _apiService = ApiService(); // API 서비스 인스턴스 생성

  /// 로그인 메소드
  /// [user]는 로그인 시도에 사용할 사용자 정보 (ID 및 비밀번호)
  /// [context]는 Navigator를 사용하기 위한 BuildContext
  void login(User user, BuildContext context) async {
    // API 요청을 통해 로그인 시도
    bool isSuccess = await _apiService.login(user); // API 요청 호출

    if (isSuccess) {
      // 로그인 성공 시 다음 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TimetableScreen()), // 로그인 성공 후 화면 전환
      );
    } else {
      // 로그인 실패 처리 (예: 에러 메시지 표시)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('로그인 실패: 아이디 또는 비밀번호를 확인하세요.')),
      );
    }
  }
}
