import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart TimeTable!'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_rounded),
            onPressed: () {
              // 알림 버튼 클릭 시 동작
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 버튼 클릭 시 동작
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            // 시간 표시
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(13, (index) {
                return Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.orange[100],
                  child: Text(
                    '${index + 9}', // 9시부터 21시까지
                    style: TextStyle(fontSize: 16), // 간결한 숫자
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
                                height: 40,
                                alignment: Alignment.center,
                                color: Colors.orange[100],
                                child: Text(
                                  day,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildClassBlock(int index, BuildContext context) {
    // 각 수업 블록을 조건에 따라 색상 및 내용 설정
    String courseName = '';
    Color color = Colors.transparent;

    // 예시: 수업 배치
    if (index == 10) {
      courseName = '공개SW실무';
      color = Colors.green;
    } else if (index == 13) {
      courseName = '웹프로그램밍';
      color = Colors.blue;
    } else if (index == 16) {
      courseName = '디지털문화의 이해';
      color = Colors.orange;
    } else if (index == 18) {
      courseName = '팀프로젝트1';
      color = Colors.pink;
    } else if (index == 21) {
      courseName = '세계화와사회변화';
      color = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
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
