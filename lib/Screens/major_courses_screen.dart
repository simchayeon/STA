import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/signup_controller.dart';
import 'package:smarttimetable/models/major_model.dart';
import 'package:smarttimetable/Screens/elective_courses_screen.dart';

class MajorCoursesScreen extends StatefulWidget {
  const MajorCoursesScreen({super.key});

  @override
  _MajorCoursesScreenState createState() => _MajorCoursesScreenState();
}

class _MajorCoursesScreenState extends State<MajorCoursesScreen> {
  final SignUpController _signUpController = SignUpController();
  List<Major> _majors = []; // 전공 목록
  final List<String> _selectedMajors = []; // 선택된 전공 목록

  @override
  void initState() {
    super.initState();
    _fetchMajors(); // 전공 목록 가져오기
  }

  // 전공 목록 가져오는 메소드
  Future<void> _fetchMajors() async {
    try {
      List<Major> majors = await _signUpController.fetchMajors();
      setState(() {
        _majors = majors;
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
        title: const Text('회원가입'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이수 완료 전공 과목 선택',
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
                    String userId = 'user_id'; // 실제 사용자 ID로 대체해야 함
                    bool success = await _signUpController.saveSelectedMajors(
                        userId, _selectedMajors);
                    if (success) {
                      print('선택된 전공이 저장되었습니다: $_selectedMajors');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ElectiveCoursesScreen()),
                      );
                    } else {
                      print('전공 저장 실패');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
      ),
    );
  }
}
