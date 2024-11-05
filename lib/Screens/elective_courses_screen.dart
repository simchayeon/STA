// 이수 완료 고양 과목 선택 페이지
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/login_screen.dart';

class ElectiveCoursesScreen extends StatelessWidget {
  const ElectiveCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.orange,
      ),
      body: const CourseSelectionPage(),
    );
  }
}

class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  final List<String> _selectedCoreCourses = []; // 선택된 핵심교양을 저장할 리스트
  final List<String> _selectedCommonCourses = []; // 선택된 공통교양을 저장할 리스트

  final List<String> _coreCourses = [
    '성서와 인간이해',
    '종교와 과학',
    '민주주의와 현대사회',
  ];

  final List<String> _commonCourses = [
    '역사와 문명',
    '일반화학',
    '채플',
  ];

  void _onNext() {
    // 선택한 과목들을 출력
    print('선택한 핵심교양: $_selectedCoreCourses');
    print('선택한 공통교양: $_selectedCommonCourses');
    // 다음 화면으로 넘어가는 로직 추가 가능

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                '이수완료 과목 선택',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '핵심교양',
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: _coreCourses.map((course) {
                return CheckboxListTile(
                  title: Text(course),
                  value: _selectedCoreCourses.contains(course),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCoreCourses.add(course);
                      } else {
                        _selectedCoreCourses.remove(course);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              '공통교양',
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: _commonCourses.map((course) {
                return CheckboxListTile(
                  title: Text(course),
                  value: _selectedCommonCourses.contains(course),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCommonCourses.add(course);
                      } else {
                        _selectedCommonCourses.remove(course);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => LoginPage()));
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
