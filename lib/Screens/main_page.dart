import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/timetable_controller.dart'; // TimetableController 임포트
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Screens/timetable_add.dart';

class TimetableScreen extends StatefulWidget {
  final String userId; // 사용자 ID를 받기 위한 필드

  const TimetableScreen({super.key, required this.userId});

  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late TimetableController _controller; // TimetableController 선언

  @override
  void initState() {
    super.initState();
    _controller = TimetableController(widget.userId); // 컨트롤러 초기화
    _fetchSubjects(); // 과목 목록 가져오기
  }

  // API에서 과목 목록 가져오는 메소드
  Future<void> _fetchSubjects() async {
    await _controller.fetchSubjects();
    setState(() {}); // 상태 업데이트
  }

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
                    '${index + 8}', // 9시부터 21시까지
                    style: const TextStyle(fontSize: 13), // 간결한 숫자
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w200),
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
                      children: List.generate(65, (index) {
                        // 인덱스가 colors의 길이와 같은지 확인
                        if (index < _controller.timetable.length) {
                          String courseName =
                              _controller.timetable[index] ?? '';
                          Color color = index < _controller.colors.length
                              ? _controller.colors[index]
                              : Colors.transparent;

                          return Container(
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(
                                  color: Colors.grey.shade300), // 회색 테두리 추가
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Center(
                              child: Text(
                                courseName.isNotEmpty ? courseName : '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          // 시간표가 비어있거나 수업이 없는 경우 빈 컨테이너 반환
                          return Container(); // 아무것도 표시하지 않음
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 아래쪽에 언더바 추가 및 크기 조정
      bottomNavigationBar: SizedBox(
        height: 80, // 언더바의 높이를 설정
        child: BottomAppBar(
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home_rounded),
                onPressed: () {
                  // 홈 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              TimetableScreen(userId: widget.userId)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () {
                  // 수업 추가 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const TimetableAdd()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.library_books_rounded),
                onPressed: () {
                  // 정보 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => InfoScreen(
                                userId: widget.userId,
                              )));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
                  // 프로필 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MyPageScreen(userId: widget.userId)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 각 수업 블록을 그리는 메소드 (위에서 사용하지 않음)
  Widget _buildClassBlock(int index) {
    String courseName = _controller.timetable[index] ?? ''; // 해당 인덱스의 수업명
    Color color = Colors.transparent; // 기본 색상

    if (courseName.isNotEmpty) {
      // 수업명이 있는 경우 색상 설정
      color = _controller.colors[index]; // 인덱스에 따른 색상 가져오기
    }

    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey.shade300), // 회색 테두리 추가
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          courseName.isNotEmpty ? courseName : '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
