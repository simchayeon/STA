import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/signup_controller.dart';
import 'package:smarttimetable/models/mj_stid_model.dart';
import 'personal_info_screen.dart';

import 'package:smarttimetable/Services/api_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final List<String> _majors = ['컴퓨터공학과'];
  final List<String> _grades = ['1', '2', '3', '4']; // 학년 드롭다운 리스트
  final List<String> _semesters = ['1', '2']; // 학기 드롭다운 리스트

  String? _selectedMajor;
  String? _selectedGrade; // 선택된 학년
  String? _selectedSemester; // 선택된 학기
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _idController =
      TextEditingController(); // 아이디 입력 컨트롤러
  bool _isIdChecked = false; // 아이디 중복 확인 체크 여부
  final SignUpController _signUpController = SignUpController();
  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성

  void _onNext() async {
    // 전공 및 학번, 아이디, 학년, 학기 정보를 모델에 저장
    MajorInfo majorInfo = MajorInfo(
      major: _selectedMajor ?? '',
      student_id: _studentIdController.text,
      id: _idController.text,
      grade: _selectedGrade ?? '', // 학년 추가
      semester: _selectedSemester ?? '', // 학기 추가
    );

    // 전공 정보 제출
    bool success = await _signUpController.submitMajorInfo(majorInfo, context);

    if (success) {
      // 다음 페이지로 이동하며 입력받은 아이디를 userId로 전달
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PersonalInfo(userId: _idController.text)), // 입력받은 아이디 전달
      );
    } else {
      // 회원가입 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('정보 저장 실패')),
      );
    }
  }

  // 아이디 중복 확인 메소드
  void _checkId() async {
    String userId = _idController.text;

    print('Checking ID: $userId'); // 입력된 아이디 출력

    // 아이디가 비어 있는 경우
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디를 입력하세요')),
      );
      return;
    }

    // 백엔드에 아이디 중복 확인 요청
    try {
      bool exists = await _apiService.checkIdExists(userId);

      print('ID Exists: $exists'); // exists 값 출력

      if (exists) {
        // 아이디가 이미 존재하는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 존재하는 아이디입니다')),
        );
        setState(() {
          _isIdChecked = false; // 체크 해제
        });
      } else {
        // 아이디가 존재하지 않는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('아이디 사용 가능합니다')),
        );
        setState(() {
          _isIdChecked = true; // 체크
        });
      }
    } catch (e) {
      // 에러 처리
      print('Error during ID check: $e'); // 오류 로그 출력

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디 중복 확인 중 오류 발생')),
      );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위와 아래 공간 공유
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                const Text(
                  '학과',
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedMajor,
                  hint: const Text('학과를 선택하세요'),
                  items: _majors.map((String major) {
                    return DropdownMenuItem<String>(
                      value: major,
                      child: Text(major),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMajor = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 학년과 학기를 수평으로 배치
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '학년',
                            style: TextStyle(fontSize: 18),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedGrade,
                            hint: const Text('학년을 선택하세요'),
                            items: _grades.map((String grade) {
                              return DropdownMenuItem<String>(
                                value: grade,
                                child: Text(grade),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGrade = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20), // 간격 추가
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '학기',
                            style: TextStyle(fontSize: 18),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedSemester,
                            hint: const Text('학기를 선택하세요'),
                            items: _semesters.map((String semester) {
                              return DropdownMenuItem<String>(
                                value: semester,
                                child: Text(semester),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedSemester = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  '학번',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '학번을 입력하세요 (예: 60240101)',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '아이디',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    suffixIcon: ElevatedButton(
                      onPressed: _checkId, // 중복 확인 버튼 클릭 시 호출
                      child: const Text('중복확인'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text("아이디 중복확인 체크"),
                  value: _isIdChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isIdChecked = value ?? true;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext, // 다음 버튼 클릭 시 호출
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
