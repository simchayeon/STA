import 'package:flutter/material.dart';

class MajorCoursesScreen extends StatefulWidget {
  @override
  _MajorCoursesScreenState createState() => _MajorCoursesScreenState();
}

class _MajorCoursesScreenState extends State<MajorCoursesScreen> {
  final List<String> _majors = const [
    'C언어프로그래밍',
    '컴퓨터공학세미나1',
    '공학입문설계',
    '객체지향프로그래밍1',
    'C언어연습',
    '자료구조',
    '객체지향프로그래밍2',
    '컴퓨터공학세미나2',
    '컴퓨터하드웨어',
    '웹프로그래밍',
    '고급객체지향프로그래밍',
    '컴퓨터공학콜로키움',
    '공개SW실무',
    '팀프로젝트1',
    '데이터베이스',
    '소프트웨어공학',
    '운영체제',
    '컴퓨터네트워크',
    '컴퓨터아키텍처',
    '시스템분석 및 설계',
    '팀프로젝트2',
    '알고리즘',
    '데이터베이스설계',
    '시스템 프로그래밍',
    '임베디드 시스템',
    '프로그래밍언어',
    '자기주도학습1',
    '컴퓨터보안',
    '컴퓨터그래픽스',
    '컴퓨터공학특론1',
    '자기주도학습2',
    '시스템클라우드보안',
    '블록체인',
    '4차산업혁명과 기업가정신',
    '기계학습',
    '캡스톤디자인',
    '네트워크컴퓨팅',
    '컴퓨터공학특론2',
    '모바일 프로그래밍',
    '인공지능',
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
                    //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                        //  builder: (content) => MajorCoursesScreen()));
                
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
