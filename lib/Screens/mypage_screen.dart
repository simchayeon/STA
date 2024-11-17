import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/major_courses_screen.dart';

class MyPageScreen extends StatelessWidget {
  // 임시 데이터
  final String name = "배윤호";
  final String department = "컴퓨터공학과";
  final String studentId = "60232851";
  final String email = "dong**@gmail.com";
  final String userId = "ff";

  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart TimeTable!'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                name, // 임시 데이터 사용
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            Text('학과 : $department'), // 임시 데이터 사용
            Text('학번 : $studentId'), // 임시 데이터 사용
            Text('아이디 : $email'), // 임시 데이터 사용
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // 이수과목 관리 페이지로 이동하는 로직
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MajorCoursesScreen(
                          userId:
                              userId)), // CourseManagementScreen은 이수과목 관리 페이지
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '이수과목 관리',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 220),
            // 로그아웃 버튼
            ElevatedButton(
              onPressed: () {
                // 로그아웃 처리
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50), // 가로 길이 최대화
              ),
              child: const Text(
                '로그아웃',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 회원탈퇴 버튼
            ElevatedButton(
              onPressed: () {
                // 회원탈퇴 처리
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50), // 가로 길이 최대화
              ),
              child: const Text(
                '회원탈퇴',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
