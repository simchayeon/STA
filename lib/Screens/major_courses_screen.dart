import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/elective_courses_screen.dart';

class MajorCoursesScreen extends StatefulWidget {
  const MajorCoursesScreen({super.key});

  @override
  _MajorCoursesScreenState createState() => _MajorCoursesScreenState();
}

class _MajorCoursesScreenState extends State<MajorCoursesScreen> {
  final List<String> _majors = const [
    '클라우드컴퓨팅',
    '백엔드 소프트웨어개발',
    '현장실습',
  ];

  final List<String> _selectedMajors = []; // 선택된 전공 목록

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // 가운데 정렬
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이수 완료 전공 과목 선택',
                style: TextStyle(
                  fontSize: 24, /*fontWeight: FontWeight.bold*/
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: _majors.map((String major) {
                    return CheckboxListTile(
                      title: Text(major),
                      value: _selectedMajors.contains(major),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedMajors.add(major);
                          } else {
                            _selectedMajors.remove(major);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 선택된 전공 목록을 출력하거나 다음 화면으로 이동하는 로직 추가
                    print('선택된 전공: $_selectedMajors');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                const ElectiveCoursesScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
      ),
    );
  }
}
