// 백엔드와 통신하는 API 요청 메소드 
// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/models/signup_model.dart';

class ApiService {
  static const String baseUrl = 'https://your-backend-url.com/api'; // 백엔드 URL

  // 회원가입 메소드
  Future<bool> signUp(SignUp signUp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'), // 회원가입 엔드포인트
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
}
