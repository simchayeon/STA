// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:smarttimetable/models/signup_model.dart';
import 'package:smarttimetable/models/user_model.dart';
import 'package:smarttimetable/models/mj_stid_model.dart';
import 'package:smarttimetable/models/per_info_model.dart';

class ApiService {
  // 백엔드 URL 설정
  static const String baseUrl =
      'https://11ff-117-17-163-57.ngrok-free.app'; // 기본 주소

  // 아이디, 전공 및 학번 정보를 제출하는 메소드
  Future<bool> submitMajorInfo(MajorInfo majorInfo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/sign'), // 전공 정보 제출 엔드포인트
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'id': majorInfo.id, // 아이디
        'major': majorInfo.major, // 학과
        'student_id': majorInfo.student_id, // 학번
      }),
    );

    print('Major Info Response: ${response.statusCode}'); // 응답 상태 코드 출력
    print('Response Body: ${response.body}'); // 응답 본문 출력

    return response.statusCode == 200; // 성공 여부 반환
  }

  // 회원가입 메소드
  Future<bool> signUp(SignUp signUp, MajorInfo majorinfo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/signup'), // 회원가입 엔드포인트
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'id': majorinfo.id, // 아이디
        'password': signUp.password, // 사용자 비밀번호
        'email': signUp.email, // 사용자 이메일
        'name': signUp.name, // 사용자 이름
      }),
    );

    print('Sign Up Response: ${response.statusCode}'); // 응답 상태 코드 출력
    print('Response Body: ${response.body}'); // 응답 본문 출력

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
