// lib/controllers/signup_controller.dart

import 'package:flutter/material.dart';
import 'package:smarttimetable/models/signup_model.dart';
import 'package:smarttimetable/services/api_service.dart';

class SignUpController {
  final ApiService _apiService = ApiService(); // API 서비스 인스턴스 생성

  Future<bool> submitSignUp(SignUp signUp) async {
    // API 요청을 통해 회원가입 정보를 제출합니다.
    return await _apiService.signUp(signUp);
  }
}
