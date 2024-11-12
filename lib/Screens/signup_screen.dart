// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/signup_controller.dart';
import 'package:smarttimetable/models/mj_stid_model.dart';
import 'personal_info_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final List<String> _majors = [
    '컴퓨터공학과',
  ];

  String? _selectedMajor;
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _idController =
      TextEditingController(); // 아이디 입력 컨트롤러
  bool _isIdChecked = false; // 아이디 중복 확인 체크 여부
  final SignUpController _signUpController = SignUpController();

  void _onNext() async {
    // 전공 및 학번, 아이디 정보를 모델에 저장
    MajorInfo majorInfo = MajorInfo(
      major: _selectedMajor ?? '',
      student_id: _studentIdController.text,
      id: _idController.text,
    );

    // 전공 정보 제출
    bool success = await _signUpController.submitMajorInfo(majorInfo, context);

    if (success) {
      // 다음 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PersonalInfo()), // 정확한 클래스 이름으로 수정
      );
    } else {
      // 회원가입 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('전공 정보 저장 실패')),
      );
    }
  }

  // 아이디 중복 확인 메소드 (서버 요청 없이 상태만 업데이트)
  void _checkId() {
    setState(() {
      // 여기서 실제 아이디 중복 확인 로직 없이 상태만 업데이트
      _isIdChecked = true; // 중복 확인 완료 상태로 변경
    });

    // 피드백 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('아이디 중복 확인 완료')),
    );
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
                const Text(
                  '학번',
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '학번을 입력하세요',
                  ),
                ),
                const SizedBox(height: 20),

                // 아이디 입력 필드 추가
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

                // 아이디 중복 확인 체크박스 추가
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
