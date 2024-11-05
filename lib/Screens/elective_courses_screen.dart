// 이수 완료 고양 과목 선택 페이지 
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/login_screen.dart';

class ElectiveCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '시간표앱',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CourseSelectionPage(),
    );
  }
}

class CourseSelectionPage extends StatefulWidget {
  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  List<String> _selectedCoreCourses = []; // 선택된 핵심교양을 저장할 리스트
  List<String> _selectedCommonCourses = []; // 선택된 공통교양을 저장할 리스트

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
      appBar: AppBar(
        title: Text('이수완료 과목 선택'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
            SizedBox(height: 20),
            Text(
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
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _onNext,
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
