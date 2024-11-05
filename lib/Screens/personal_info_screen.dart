// 개인 정보 입력받는 페이지 구현
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/major_courses_screen.dart';

class PersonlaInfo extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<PersonlaInfo> {
  bool _isIdChecked = false;
  TextEditingController _idController = TextEditingController();

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
        title: const Text('개인 정보 입력'),
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
                  child: Text('중복확인'),
                ),
              ),
            ),
            CheckboxListTile(
              title: Text("아이디 중복확인 체크"),
              value: _isIdChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isIdChecked = value ?? false;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: '이메일',
                suffixIcon: ElevatedButton(
                  onPressed: () {},
                  child: Text('인증번호보내기'),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(labelText: '인증번호 확인'),
            ),
            TextField(
              decoration: InputDecoration(labelText: '이름'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _onNext, // 다음 버튼 클릭 시 _onNext 호출
                child: Text('다음'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
