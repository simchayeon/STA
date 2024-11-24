import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smarttimetable/models/subject_model.dart';
import 'package:smarttimetable/services/api_service.dart';

class TimetableController {
  final String userId;
  List<Subject> subjects = []; // 과목 리스트
  List<String?> timetable = List.filled(65, null); // 65개의 셀 초기화
  List<Color> colors = []; // 과목 색상 리스트

  TimetableController(this.userId);

  // API에서 과목 목록 가져오기
  Future<void> fetchSubjects() async {
    ApiService apiService = ApiService();
    subjects = await apiService.fetchCurrentSubjects(userId);
    updateTimetable(); // 시간표 업데이트
  }

  void updateTimetable() {
    Map<String, Color> courseColors = {}; // 과목 색상 저장
    Random random = Random();

    // 각 과목에 대해 시간표를 업데이트
    for (var subject in subjects) {
      // classTime을 분석하여 요일 및 시간 가져오기
      List<String> classDetails = subject.classTime.split(','); // 요일과 시간을 분리
      for (var detail in classDetails) {
        // "화(11:00-12:50)" 형식에서 요일과 시간 분리
        String day = detail.substring(0, 1); // 요일 (예: "화")
        String timeRange =
            detail.substring(2, detail.length - 1); // 시간 (예: "11:00-12:50")

        // 요일에 따른 인덱스 계산
        int dayIndex = getDayIndex(day); // 요일 인덱스 계산
        int timeIndex = getTimeIndex(timeRange); // 시간 인덱스 계산

        Color color;
        // 과목 색상 결정
        if (courseColors.containsKey(subject.name)) {
          color = courseColors[subject.name]!; // 기존 색상 사용
        } else {
          color = Color.fromARGB(255, random.nextInt(256), random.nextInt(256),
              random.nextInt(256)); // 랜덤 색상 생성
          courseColors[subject.name] = color; // 색상 저장
        }

        // 수업의 길이 계산
        int duration = calculateDuration(timeRange); // 수업의 길이 계산
        for (int i = 0; i < duration; i++) {
          int currentIndex = dayIndex +
              (timeIndex * 5) +
              (i * 5); // 요일 인덱스 + (시간 인덱스 * 5) + (수업 길이에 따른 인덱스 조정)
          if (currentIndex < timetable.length) {
            timetable[currentIndex] = subject.name; // 수업명 저장
            colors.add(color); // 색상 저장
          }
        }
      }
    }
  }

// 요일에 따른 인덱스 계산
  int getDayIndex(String day) {
    switch (day) {
      case '월':
        return 0; // 월요일
      case '화':
        return 1; // 화요일
      case '수':
        return 2; // 수요일
      case '목':
        return 3; // 목요일
      case '금':
        return 4; // 금요일
      default:
        return -1;
    }
  }

// 시간에 따른 인덱스 계산
  int getTimeIndex(String timeRange) {
    String startTime = timeRange.split('-')[0]; // 시작 시간 (예: "11:00")
    int startHour = int.parse(startTime.substring(0, 2)); // 시작 시간의 시
    return startHour - 8; // 8시부터 시작하므로
  }

// 수업의 길이 계산 (예: 11:00-12:50 -> 2시간)
  int calculateDuration(String timeRange) {
    String startTime = timeRange.split('-')[0]; // 시작 시간
    String endTime = timeRange.split('-')[1]; // 종료 시간

    int startHour = int.parse(startTime.substring(0, 2));
    int endHour = int.parse(endTime.substring(0, 2));

    // 50분 단위로 계산
    int duration = (endHour - startHour) + ((endTime[3] == '0') ? 0 : 1);
    return duration; // 지속 시간 반환
  }
}
