import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Screens/timetable_add.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart TimeTable!'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            // 시간 표시
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(13, (index) {
                return Container(
                  width: 30,
                  height: 49,
                  alignment: Alignment.center,
                  color: Colors.white10,
                  child: Text(
                    /*index == 0 || index == 13
                        ? ''
                        : */
                    '${index + 8}', // 9시부터 21시까지
                    style: TextStyle(fontSize: 13), // 간결한 숫자
                  ),
                );
              }),
            ),
            // 시간표 그리드
            Expanded(
              child: Column(
                children: [
                  // 요일 표시
                  Row(
                    children: ['월', '화', '수', '목', '금']
                        .map((day) => Expanded(
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                color: Colors.white10,
                                child: Text(
                                  day,
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  // 시간표 그리드
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 5, // 5일 (월~금)
                      childAspectRatio: 1.5, // 각 셀의 비율
                      children: [
                        for (var i = 0; i < 65; i++) // 13시간 * 5일 = 65 셀
                          _buildClassBlock(i, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 아래쪽에 언더바 추가 및 크기 조정
      bottomNavigationBar: Container(
        height: 80, // 언더바의 높이를 설정
        child: BottomAppBar(
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home_rounded),
                onPressed: () {
                  // 홈 버튼 클릭 시 동작
                },
              ),
              IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: () {
                  // 수업 추가 버튼 클릭 시 동작
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => TimetableAdd()));
                },
              ),
              IconButton(
                icon: Icon(Icons.library_books_rounded),
                onPressed: () {
                  // 정보 버튼 클릭 시 동작
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => InfoScreen()));
                },
              ),
              IconButton(
                icon: Icon(Icons.person_rounded),
                onPressed: () {
                  // 프로필 버튼 클릭 시 동작
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => MyPageScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassBlock(int index, BuildContext context) {
    // 각 수업 블록을 조건에 따라 색상 및 내용 설정
    String courseName = '';
    Color color = Colors.transparent;

    // 예시: 수업 배치
    if (index == 10) {
      courseName = '공개SW실무';
      color = const Color.fromARGB(255, 255, 242, 99);
    } else if (index == 13) {
      courseName = '웹프로그램밍';
      color = const Color.fromARGB(255, 215, 222, 90);
    } else if (index == 16) {
      courseName = '디지털문화의 이해';
      color = const Color.fromARGB(255, 255, 173, 49);
    } else if (index == 18) {
      courseName = '팀프로젝트1';
      color = const Color.fromARGB(255, 255, 203, 98);
    } else if (index == 21) {
      courseName = '세계화와사회변화';
      color = const Color.fromARGB(255, 221, 138, 60);
    }

    return Container(
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey.shade300), // 회색 테두리 추가
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          courseName.isNotEmpty ? courseName : '',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
