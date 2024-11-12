// 개인 정보 입력받는 페이지 구현
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/major_courses_screen.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<PersonalInfo> {
  bool _isIdChecked = true;
  final TextEditingController _idController = TextEditingController();

  void _checkId() {
    setState(() {
      _isIdChecked = true;
    });
  }

  void _onNext() {
    // MajorCoursesScreen으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MajorCoursesScreen()),
    );
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
            
            const TextField(
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: '이메일',
              ),
            ),
            const TextField(
              decoration: InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 10),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const MajorCoursesScreen()));
                },
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
