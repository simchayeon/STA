import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/main_page.dart';
import 'package:smarttimetable/Screens/signup_screen.dart';
import 'major_courses_screen.dart';
import 'find_id_screen.dart';
import 'find_password_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key); // const 생성자 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        backgroundColor: Colors.orange,
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ForgotPassword(),
            SizedBox(height: 20),
            LoginButton(),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key); // 'key'를 부모 클래스에 전달

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.stars_rounded, size: 100, color: Colors.orange),
        SizedBox(width: 8),
        Text(
          'STA',
          style: TextStyle(
            fontSize: 36,
            color: Colors.orange,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key); // 'key'를 부모 클래스에 전달

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FindIDScreen()),
            );
          },
          child: const Text(
            '아이디 찾기',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 비밀번호 찾기 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FindPasswordScreen()),
            );
          },
          child: const Text('비밀번호 찾기', style: TextStyle(color: Colors.blue)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          child: const Text('회원가입', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key); // 'key'를 부모 클래스에 전달

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // 로그인 버튼 클릭 시 동작
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => TimetableScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}
