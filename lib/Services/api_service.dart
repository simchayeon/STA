// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/models/signup_model.dart';
import 'package:smarttimetable/models/user_model.dart';

class ApiService {
  // 백엔드 URL 설정
  static const String baseUrl = 'http://117.17.163.57'; // 기본 주소

  // 회원가입 메소드
  Future<bool> signUp(SignUp signUp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/signup'), // 회원가입 엔드포인트
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'major': signUp.major, // 학과
        'student_id': signUp.studentId, // 학번
      }),
    );

    return response.statusCode == 201; // 회원가입 성공 여부 반환
  }

  // 로그인 메소드
  Future<bool> login(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/login'), // 로그인 엔드포인트
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'id': user.id, // 사용자 ID
        'password': user.password, // 비밀번호
      }),
    );

    return response.statusCode == 200; // 로그인 성공 여부 반환
  }
}
