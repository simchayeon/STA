import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // 로그인 페이지 임포트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '로그인 페이지',
      home: LoginPage(), // const 제거
    );
  }
}
