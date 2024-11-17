import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:smarttimetable/models/elective_model.dart';
import 'package:smarttimetable/models/major_model.dart';
import 'package:smarttimetable/models/per_info_model.dart';
import 'package:smarttimetable/models/elective_model.dart';
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

  // 전공 목록 가져오기 (중복 필터링 포함)
  Future<List<Major>> fetchMajors() async {
    try {
      List<Major> allMajors =
          await _apiService.fetchMajors(); // API에서 전공 목록 가져오기

      // 앞 6자리가 같은 전공 필터링
      Set<String> uniqueMajorNames = {};
      List<Major> filteredMajors = [];

      for (var major in allMajors) {
        String prefix = major.name.length >= 6
            ? major.name.substring(0, 6)
            : major.name; // 길이가 6 미만일 경우 처리
        if (!uniqueMajorNames.contains(prefix)) {
          uniqueMajorNames.add(prefix);
          filteredMajors.add(major); // 중복되지 않은 전공만 추가
        }
      }

      return filteredMajors; // 필터링된 전공 리스트 반환
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

  // 공통 교양 목록 가져오기
  Future<List<ElectiveCourse>> fetchCommonElectives() async {
    try {
      return await _apiService
          .fetchCommonElectives(); // ApiService의 fetchCommonElectives 호출
    } catch (e) {
      throw Exception('Failed to fetch common electives: $e'); // 오류 처리
    }
  }

  // 핵심 교양 목록 가져오기
  Future<List<ElectiveCourse>> fetchCoreElectives() async {
    try {
      return await _apiService
          .fetchCoreElectives(); // ApiService의 fetchCoreElectives 호출
    } catch (e) {
      throw Exception('Failed to fetch core electives: $e'); // 오류 처리
    }
  }

  // 선택한 교양 과목 저장하기
  Future<bool> saveSelectedElectives(
      String userId,
      List<String> selectedCoreCourses,
      List<String> selectedCommonCourses) async {
    try {
      return await _apiService.saveSelectedElectives(
          userId,
          selectedCoreCourses,
          selectedCommonCourses); // ApiService의 saveSelectedElectives 호출
    } catch (e) {
      throw Exception('Failed to save selected electives: $e'); // 오류 처리
    }
  }
}
