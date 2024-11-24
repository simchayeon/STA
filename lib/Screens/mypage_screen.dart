import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/login_screen.dart';
import 'package:smarttimetable/Screens/major_courses_screen.dart';

class MyPageScreen extends StatelessWidget {
  // 임시 데이터
  final String name = "배윤호";
  final String department = "컴퓨터공학과";
  final String studentId = "60232851";
  final String email = "dong**@gmail.com";
  final String userId = "ff";

  // 임시 데이터 추가
  final String grade = "2학년";
  final String semester = "2학기";

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
            const SizedBox(height: 20),
            Text('학과 : $department'), // 임시 데이터 사용
            Text('학번 : $studentId'), // 임시 데이터 사용
            Text('아이디 : $email'), // 임시 데이터 사용
            const SizedBox(height: 20),

            // 학년과 학기를 수평으로 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('학년 : $grade'), // 임시 데이터 사용
                Text('학기 : $semester'), // 임시 데이터 사용
                TextButton(
                  onPressed: () {
                    _showEditDialog(context); // 수정하기 로직
                  },
                  child: const Text(
                    '수정하기',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
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
                    '전공 이수 과목 관리',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // 이수과목 관리2 버튼과의 간격
            GestureDetector(
              onTap: () {
                // 이수과목 관리2 페이지로 이동하는 로직
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
                    '교양 이수 과목 관리',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const Spacer(), // 남은 공간을 채워서 버튼을 아래로 밀어냄

            // 로그아웃 버튼
            ElevatedButton(
              onPressed: () {
                // 로그아웃 처리
                _logout(context);
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

  void _showEditDialog(BuildContext context) {
    String? newGrade;
    String? newSemester;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정보 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                isExpanded: true,
                value: newGrade,
                hint: const Text('학년을 선택하세요'),
                items: ['1', '2', '3', '4'].map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (String? value) {
                  newGrade = value;
                },
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: newSemester,
                hint: const Text('학기를 선택하세요'),
                items: ['1', '2'].map((String semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (String? value) {
                  newSemester = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 수정하기 로직 추가 가능
                // 예를 들어, 새로운 학년과 학기를 상태에 반영하는 코드
                Navigator.of(context).pop();
              },
              child: const Text('수정하기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    // 로그아웃 처리 로직
    // 예를 들어, 세션 또는 토큰 삭제 코드를 여기에 추가
    // SharedPreferences 등을 사용하여 저장된 사용자 정보를 삭제할 수 있습니다.

    // 로그아웃 후 로그인 화면으로 이동
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // 로그인 화면으로 이동
      (route) => false, // 모든 이전 화면 제거
    );
  }
}
