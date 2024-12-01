import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/timetable_controller.dart'; // TimetableController 임포트
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Services/api_service.dart';
import 'package:smarttimetable/models/subject_model.dart';
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
                          /*Color color = index < _controller.colors.length
                              ? _controller.colors[index]
                              : Colors.transparent;*/
                          Color color = Colors.transparent;

                          if (index < _controller.colors.length) {
                            color =
                                _controller.colors[index] ?? Colors.transparent;
                          }

                          //print(
                          //  'Index: $index, Course Name: $courseName, Color: $color');

                          return GestureDetector(
                            onTap: () {
                              // 수업명이 비어있지 않은 경우에만 다이얼로그를 표시
                              if (index < _controller.timetable.length) {
                                String courseName =
                                    _controller.timetable[index] ?? '';
                                if (courseName.isNotEmpty) {
                                  _controller.showSubjectDialog(
                                      context, courseName, () async {
                                    await _deleteClass(index);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  });
                                }
                              }
                            },
                            child: Container(
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
                          builder: (content) => TimetableAdd(
                                userId: widget.userId,
                              )));
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
                          builder: (content) =>
                              MyPageScreen(userId: widget.userId)));
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

    /*if (courseName.isNotEmpty) {
      // 수업명이 있는 경우 색상 설정
      color = _controller.colors[index]; // 인덱스에 따른 색상 가져오기
    }*/
    if (courseName.isNotEmpty) {
      if (index < _controller.colors.length) {
        color = _controller.colors[index] ?? Colors.transparent; // 색상 가져오기
      }
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

/* 수업 상세 정보 다이얼로그
  void _showClassDetailDialog(int index) {
    String courseName = _controller.timetable[index] ?? '미정';
    Color color = _controller.colors[index] ?? Colors.transparent;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(courseName),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('상세 정보: 여기서 수업의 세부 정보를 보여줍니다.'),
              // 추가적으로 수업의 세부 정보를 여기에 표시할 수 있습니다.
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // 수업 삭제 로직 (백엔드에 요청)
                _deleteClass(index);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
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
  }*/
  Future<void> _deleteClass(int index) async {
    // 인덱스 유효성 검사
    if (index < 0 || index >= _controller.timetable.length) {
      print('Invalid index: $index'); // 디버깅을 위한 로그
      return;
    }

    String courseName = _controller.timetable[index] ?? '';

    // 과목 이름이 비어있지 않은 경우에만 삭제 요청
    if (courseName.isNotEmpty) {
      try {
        // 백엔드에 과목 삭제 요청
        await ApiService().deleteSubject(widget.userId, courseName);

        // 서버에서 최신 과목 목록 가져오기
        await _fetchSubjects(); // 최신 과목 목록 가져오기

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수업이 삭제되었습니다.')),
        );
      } catch (e) {
        // 오류 발생 시 사용자에게 알림
        print('Error during deletion: $e'); // 오류 로그 추가
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수업 삭제 중 오류가 발생했습니다.')),
        );
      }
    }
  }
}
