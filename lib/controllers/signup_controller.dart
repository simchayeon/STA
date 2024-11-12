import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:smarttimetable/models/major_model.dart';
import 'package:smarttimetable/models/per_info_model.dart';
import 'package:smarttimetable/models/major_model.dart';
import 'package:smarttimetable/models/mj_stid_model.dart';
//import 'package:smarttimetable/models/user_model.dart'; // SignUp 모델 임포트
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
      SignUp signUp, String userId, BuildContext context) async {
    _logger.info('Calling submitSignUp...'); // 메소드 호출 로그

    try {
      // API 요청을 통해 회원가입 정보를 제출합니다.
      bool success = await _apiService.signUp(signUp, userId); // userId를 전달
      if (success) {
        // 회원가입 성공 시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공!')),
        );
      } else {
        // 회원가입 실패 시 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 실패')),
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

  // 전공 목록 가져오기
  Future<List<Major>> fetchMajors() async {
    try {
      return await _apiService.fetchMajors(); // ApiService의 fetchMajors 호출
    } catch (e) {
      throw Exception('Failed to fetch majors: $e'); // 오류 처리
    }
  }

  // 선택한 전공 과목 저장하기
  Future<bool> saveSelectedMajors(
      String userId, List<String> selectedMajors) async {
    try {
      return await _apiService.saveSelectedMajors(
          userId, selectedMajors); // ApiService의 saveSelectedMajors 호출
    } catch (e) {
      throw Exception('Failed to save selected majors: $e'); // 오류 처리
    }
  }
}
