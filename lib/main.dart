import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'screens/login_screen.dart'; // 로그인 페이지 임포트
import 'controllers/login_controller.dart';
import 'models/user_model.dart';
import 'Screens/major_courses_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '로그인 페이지',
      home: InfoScreen(), // const 제거
    );
  }
}
