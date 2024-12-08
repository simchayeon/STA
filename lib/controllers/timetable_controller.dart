import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/main_page.dart';
import 'package:smarttimetable/models/addmajor_model.dart';
import 'package:smarttimetable/models/subject_model.dart';
import 'package:smarttimetable/Services/api_service.dart';

class TimetableController extends ChangeNotifier {
  final String userId;
  List<Subject> subjects = []; // 과목 리스트
  final List<AddMajor> _subjects = [];
  List<String?> timetable = List.filled(65, null); // 65개의 셀 초기화
  List<Color?> colors = List.filled(65, null); // 과목 색상 리스트

  TimetableController(this.userId);

  // API에서 과목 목록 가져오기
  Future<dynamic> fetchSubjects() async {
    print("디버깅용 출력");
    ApiService apiService = ApiService();
    subjects = await apiService.fetchCurrentSubjects(userId);
    print(
        'Fetched subjects: ${subjects.map((s) => s.name).toList()}'); // 과목 이름 로그
    updateTimetable(); // 시간표 업데이트
    return subjects;
  }

  // 과목 목록을 반환하는 함수
  List<AddMajor> getSubjects() {
    return _subjects; // _subjects에 저장된 데이터를 반환
  }

  // 과목 삭제 메소드
  void deleteSubject(String courseName) {
    timetable.removeWhere((subject) => subject == courseName); // 과목 삭제
    notifyListeners(); // 상태 변경 알림
  }

  void showSubjectDialog(BuildContext context, String courseName,
      Future<void> Function() onDelete) {
    // 과목 이름으로 Subject 찾기
    Subject? subject = subjects.firstWhere(
      (s) => s.name == courseName,
    );

    /* 과목 삭제 메소드
    void deleteSubject(String courseName) {
      print('Deleting subject: $courseName'); // 로그 추가
      subjects
          .removeWhere((subject) => subject.name == courseName); // 로컬에서 과목 삭제
      updateTimetable(); // 시간표 업데이트
      notifyListeners(); // UI 업데이트 알림
    }*/

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(subject.name), // 강의명 표시
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬

            children: [
              Text('교수명: ${subject.professor}'), // 교수명 표시
              Text('요일 및 시간: ${subject.classTime}'), // 요일 및 시간 표시
              Text('강좌번호: ${subject.lectureNumber}'), // 강좌번호 표시
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                // 수업 삭제 로직 (백엔드에 요청)
                await onDelete(); // 과목 이름으로 삭제
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 상태가 여전히 활성화되어 있는지 확인
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TimetableScreen(userId: userId),
                    ),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
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

        print(
            'Processing class: ${subject.name}, Day: $day, Time Range: $timeRange'); // 로그 추가

        // 요일에 따른 인덱스 계산
        int dayIndex = getDayIndex(day); // 요일 인덱스 계산
        print('dayIndex: $dayIndex'); // 요일 인덱스 로그

        int timeIndex = getTimeIndex(timeRange); // 시간 인덱스 계산

        /*Color color;
        // 과목 색상 결정
        if (courseColors.containsKey(subject.name)) {
          color = courseColors[subject.name]!; // 기존 색상 사용
        } else {
          color = Color.fromARGB(255, random.nextInt(256), random.nextInt(256),
              random.nextInt(256)); // 랜덤 색상 생성
          courseColors[subject.name] = color; // 색상 저장
        }*/

        // 색상 할당
        Color color;
        if (courseColors.containsKey(subject.name)) {
          color = courseColors[subject.name]!; // 기존 색상 사용
        } else {
          color = _getRandomColor(); // 새로운 색상 생성
          courseColors[subject.name] = color; // 수업 이름과 색상 매핑
        }

        // 수업의 길이 계산
        int duration = calculateDuration(timeRange); // 수업의 길이 계산
        print('Duration for ${subject.name}: $duration'); // 수업 길이 로그
        print('timeIndex: $timeIndex'); // 수업 길이 로그

        for (int i = 0; i < duration; i++) {
          int currentIndex = dayIndex +
              (timeIndex * 5) +
              (i * 5); // 요일 인덱스 + (시간 인덱스 * 5) + (수업 길이에 따른 인덱스 조정)
          print('currentIndex: $currentIndex'); // 수업 길이 로그

          if (currentIndex < timetable.length) {
            timetable[currentIndex] = subject.name; // 수업명 저장
            colors[currentIndex] = color; // 색상 저장
          }
        }
      }
    }
    print('Fetched subjects: ${subjects.map((s) => s.name).toList()}');
  }

// 요일에 따른 인덱스 계산
  int getDayIndex(String day) {
    print('Getting day index for: $day'); // 로그 추가

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
    try {
      String startTime = timeRange.split('-')[0]; // 시작 시간
      if (startTime.length < 4) {
        throw FormatException('Invalid time format: $startTime');
      }
      int startHour = int.parse(startTime.substring(0, 2)); // 시작 시간의 시
      print('Start hour: $startHour'); // 시작 시간 로그

      return startHour - 8; // 8시부터 시작하므로
    } catch (e) {
      print('Error parsing time range: $e');
      return -1; // 오류 발생 시 -1 반환
    }
  }

// 수업의 길이 계산 (예: 11:00-12:50 -> 2시간)
  int calculateDuration(String timeRange) {
    try {
      String startTime = timeRange.split('-')[0]; // 시작 시간
      String endTime = timeRange.split('-')[1]; // 종료 시간

      if (startTime.length < 4 || endTime.length < 4) {
        throw FormatException('Invalid time format: $timeRange');
      }

      int startHour = int.parse(startTime.substring(0, 2)); // 시작 시간의 시
      int endHour = int.parse(endTime.substring(0, 2)); // 종료 시간의 시

      // 50분 단위로 계산
      int duration = (endHour - startHour) + ((endTime[2] == '0') ? 0 : 1);
      print('Calculated duration: $duration'); // 지속 시간 로그

      return duration; // 지속 시간 반환
    } catch (e) {
      print('Error calculating duration: $e');
      return 0; // 오류 발생 시 0 반환
    }
  }

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }
}
