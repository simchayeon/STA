// 개인 정보 입력받는 페이지 구현
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/major_courses_screen.dart';

class PersonlaInfo extends StatefulWidget {
  const PersonlaInfo({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<PersonlaInfo> {
  bool _isIdChecked = false;
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
      MaterialPageRoute(builder: (context) => MajorCoursesScreen()),
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
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: '아이디',
                suffixIcon: ElevatedButton(
                  onPressed: _checkId,
                  child: const Text('중복확인'),
                ),
              ),
            ),
            CheckboxListTile(
              title: const Text("아이디 중복확인 체크"),
              value: _isIdChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isIdChecked = value ?? false;
                });
              },
            ),
            const TextField(
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const TextField(
              decoration: InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
                suffixIcon: ElevatedButton(
                  onPressed: () {},
                  child: const Text('인증번호보내기'),
                ),
              ),
            ),
            const TextField(
              decoration: InputDecoration(labelText: '인증번호 확인'),
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
                          builder: (content) => MajorCoursesScreen()));
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
