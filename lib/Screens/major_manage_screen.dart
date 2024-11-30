import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/signup_controller.dart';
import 'package:smarttimetable/Services/api_service.dart';
import 'package:smarttimetable/models/major_model.dart';

class MajorManageScreen extends StatefulWidget {
  final String userId;

  const MajorManageScreen({super.key, required this.userId});

  @override
  _MajorManageScreenState createState() => _MajorManageScreenState();
}

class _MajorManageScreenState extends State<MajorManageScreen> {
  final SignUpController _signUpController = SignUpController();
  final ApiService _apiService = ApiService();
  List<Major> _majors = []; // 전체 전공 목록
  final List<String> _selectedMajors = []; // 선택된 전공 목록

  @override
  void initState() {
    super.initState();
    _fetchMajors(); // 전공 목록 가져오기
  }

  // 전공 목록 가져오는 메소드
  Future<void> _fetchMajors() async {
    try {
      // 전체 전공 과목 목록 가져오기
      List<Major> majors = await _signUpController.fetchMajors();
      setState(() {
        _majors = majors;
      });

      // 사용자가 선택한 전공 과목 가져오기
      List<String> completedMajors =
          await _apiService.fetchCompletedMajors(widget.userId);

      // 앞 6자리로 중복 제거
      List<String> uniqueCompletedMajors = [];
      Set<String> seen = {};

      for (var major in completedMajors) {
        String prefix = major.length >= 6 ? major.substring(0, 6) : major;
        if (!seen.contains(prefix)) {
          seen.add(prefix);
          uniqueCompletedMajors.add(major);
        }
      }

      setState(() {
        _selectedMajors.addAll(uniqueCompletedMajors); // 체크된 상태로 초기화
      });
    } catch (e) {
      // 오류 처리 (예: 사용자에게 알림)
      print('Error fetching majors: $e');
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이수 완료 전공 과목 관리',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: _majors.map((Major major) {
                    return CheckboxListTile(
                      title: Text(major.name),
                      value: _selectedMajors.contains(major.name),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedMajors.add(major.name);
                          } else {
                            _selectedMajors.remove(major.name);
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
                  onPressed: () async {
                    // 선택된 전공 목록을 API에 저장
                    bool success = await _apiService.saveSelectedMajors(
                        widget.userId, _selectedMajors);
                    if (success) {
                      print('선택된 전공이 저장되었습니다: $_selectedMajors');
                      Navigator.pop(context); // 이전 페이지로 돌아가기
                    } else {
                      print('전공 저장 실패');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    '저장',
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
      ),
    );
  }
}
