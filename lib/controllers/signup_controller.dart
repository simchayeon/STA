// lib/controllers/signup_controller.dart

import 'package:flutter/material.dart';
import 'package:smarttimetable/models/signup_model.dart';
import 'package:smarttimetable/services/api_service.dart';

class SignUpController {
  final ApiService _apiService = ApiService(); // API 서비스 인스턴스 생성

  Future<bool> submitSignUp(SignUp signUp, BuildContext context) async {
    try {
      // API 요청을 통해 회원가입 정보를 제출합니다.
      bool success = await _apiService.signUp(signUp);
      if (success) {
        // 회원가입 성공 시 추가 처리 (예: 성공 메시지 표시)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('아이디 및 비밀번호 정보 저장 완료')),
        );
      } else {
        // 회원가입 실패 시 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 실패: 다시 시도하세요.')),
        );
      }
      return success;
    } catch (e) {
      // 예외 발생 시 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: ${e.toString()}')),
      );
      return false;
    }
  }
}
