// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/signup_controller.dart';
import 'package:smarttimetable/models/signup_model.dart';
import 'package:smarttimetable/screens/personal_info_screen.dart';

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
  final SignUpController _signUpController = SignUpController();

  void _onNext() async {
    /*// 회원가입 정보 제출
    SignUp signUp = SignUp(
      major: _selectedMajor ?? '',
      studentId: _studentIdController.text,
    );

    bool success = await _signUpController.submitSignUp(signUp);
    if (success) {
      // 다음 화면으로 넘어가는 로직
      */
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonlaInfo()),
    ); /*
    } else {
      // 회원가입 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 실패')),
      );
    }*/
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
