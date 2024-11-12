// lib/controllers/signup_controller.dart

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:smarttimetable/models/per_info_model.dart';
import 'package:smarttimetable/models/mj_stid_model.dart';
import 'package:smarttimetable/models/user_model.dart'; // SignUp 모델 임포트
import 'package:smarttimetable/services/api_service.dart';

class SignUpController {
  final Logger _logger = Logger('SIGNCONT');

  final ApiService _apiService = ApiService(); // API 서비스 인스턴스 생성

  /// 전공 및 학번 정보를 제출하는 메소드
  Future<bool> submitMajorInfo(
      MajorInfo majorInfo, BuildContext context) async {
    _logger.info('Calling submitMajorInfo...'); // 메소드 호출 로그

    try {
      // API 요청을 통해 전공 및 학번 정보를 제출합니다.
      bool success = await _apiService.submitMajorInfo(majorInfo);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('전공 정보 저장 완료')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('전공 정보 저장 실패: 다시 시도하세요.')),
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

  /// 회원가입 정보를 제출하는 메소드
  Future<bool> submitSignUp(
      SignUp signUp, MajorInfo majorinfo, BuildContext context) async {
    try {
      // API 요청을 통해 회원가입 정보를 제출합니다.
      bool success = await _apiService.signUp(signUp, majorinfo);
      if (success) {
        // 회원가입 성공 시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
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

  /// 아이디 중복 확인 메소드 (UI만 상태 업데이트)
  void checkIdAvailability(BuildContext context) {
    // 사용자에게 아이디 중복 확인 완료 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('아이디 중복 확인 완료')),
    );
  }
}
