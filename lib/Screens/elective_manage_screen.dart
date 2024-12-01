import 'package:flutter/material.dart';
import 'package:smarttimetable/Services/api_service.dart';
import 'package:smarttimetable/controllers/signup_controller.dart'; // SignUpController 임포트
import 'package:smarttimetable/models/elective_model.dart'; // ElectiveCourse 모델 임포트
import 'package:smarttimetable/Screens/login_screen.dart';

class ElectiveManageScreen extends StatefulWidget {
  final String userId; // 사용자 ID를 받기 위한 필드

  const ElectiveManageScreen({super.key, required this.userId});

  @override
  _ElectiveCoursesScreenState createState() => _ElectiveCoursesScreenState();
}

class _ElectiveCoursesScreenState extends State<ElectiveManageScreen> {
  final SignUpController _signUpController = SignUpController();
  List<ElectiveCourse> _coreCourses = []; // 핵심 교양 과목 리스트
  List<ElectiveCourse> _commonCourses = []; // 공통 교양 과목 리스트
  final List<String> _selectedCoreCourses = []; // 선택된 핵심 교양 저장
  final List<String> _selectedCommonCourses = []; // 선택된 공통 교양 저장
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCourses(); // 과목 목록 가져오기
  }

  // 과목 목록 가져오는 메소드
  Future<void> _fetchCourses() async {
    try {
      _coreCourses = await _signUpController.fetchCoreElectives();
      _commonCourses = await _signUpController.fetchCommonElectives();
      setState(() {}); // 상태 업데이트

      // 사용자가 선택한 핵심 교양 가져오기
      List<String> completedCore =
          await _apiService.fetchCompletedCore(widget.userId);

      // 앞 6자리로 중복 제거
      List<String> uniqueCompletedCore = [];
      Set<String> seen = {};

      for (var major in completedCore) {
        String prefix = major.length >= 6 ? major.substring(0, 6) : major;
        if (!seen.contains(prefix)) {
          seen.add(prefix);
          uniqueCompletedCore.add(major);
        }
      }

      // 사용자가 선택한 공통 교양 가져오기
      List<String> completedCommon =
          await _apiService.fetchCompletedCommon(widget.userId);

      // 앞 6자리로 중복 제거
      List<String> uniqueCompletedCommon = [];
      Set<String> seenn = {};

      for (var major in completedCommon) {
        String prefix = major.length >= 6 ? major.substring(0, 6) : major;
        if (!seenn.contains(prefix)) {
          seenn.add(prefix);
          uniqueCompletedCommon.add(major);
        }
      }

      setState(() {
        _selectedCoreCourses.addAll(uniqueCompletedCore);
        _selectedCommonCourses.addAll(uniqueCompletedCommon);
        //_selectedElectives.addAll(uniqueCompletedMajors); // 체크된 상태로 초기화
      });
    } catch (e) {
      // 오류 처리
      print('Error fetching courses: $e');
    }
  }

  void _onNext() async {
    // 선택한 과목들을 백엔드에 저장
    bool success = await _signUpController.saveSelectedElectives(
        widget.userId, _selectedCoreCourses, _selectedCommonCourses);
    if (success) {
      print('선택한 과목이 저장되었습니다: $_selectedCoreCourses, $_selectedCommonCourses');
      Navigator.pop(context);
    } else {
      print('과목 저장 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('과목 관리'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '이수 완료 교양 과목 관리',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              '핵심교양',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: ListView(
                children: _coreCourses.map((course) {
                  return CheckboxListTile(
                    title: Text(course.name),
                    value: _selectedCoreCourses.contains(course.name),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedCoreCourses.add(course.name);
                        } else {
                          _selectedCoreCourses.remove(course.name);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '공통교양',
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: ListView(
                children: _commonCourses.map((course) {
                  return CheckboxListTile(
                    title: Text(course.name),
                    value: _selectedCommonCourses.contains(course.name),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedCommonCourses.add(course.name);
                        } else {
                          _selectedCommonCourses.remove(course.name);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext, // 다음 버튼 클릭 시 _onNext 메소드 호출
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 18), // 세로 패딩 조정
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}