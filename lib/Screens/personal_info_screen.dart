import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/signup_controller.dart';
import 'package:smarttimetable/models/per_info_model.dart'; // MajorInfo 모델 임포트
import 'package:smarttimetable/models/user_model.dart'; // SignUp 모델 임포트
import 'package:smarttimetable/Screens/major_courses_screen.dart';

class PersonalInfo extends StatefulWidget {
  final String userId; // 사용자 ID를 받기 위한 필드

  const PersonalInfo({super.key, required this.userId}); // 생성자에서 ID를 받음

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final SignUpController _signUpController = SignUpController();

  Future<void> _onNext() async {
    // 비밀번호 확인
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    // SignUp 모델 생성
    SignUp signup = SignUp(
      //id: widget.userId, // 전달받은 userId 사용
      email: _emailController.text,
      name: _nameController.text,
      password: _passwordController.text,
    );

    // 회원가입 정보 제출
    bool success =
        await _signUpController.submitSignUp(signup, widget.userId, context);

    if (success) {
      // 회원가입 성공 시 다음 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MajorCoursesScreen(userId: widget.userId,),
        ),
      );
    } else {
      // 회원가입 실패 시 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 실패: 다시 시도하세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 10),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext,
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
