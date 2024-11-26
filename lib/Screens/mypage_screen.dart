import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/elective_manage_screen.dart';
import 'package:smarttimetable/Screens/login_screen.dart';
import 'package:smarttimetable/Screens/major_courses_screen.dart';
import 'package:smarttimetable/Screens/major_manage_screen.dart';
import 'package:smarttimetable/models/mypage_model.dart';
import 'package:smarttimetable/services/api_service.dart'; // ApiService 임포트

class MyPageScreen extends StatefulWidget {
  final String userId; // 사용자 ID를 받기 위한 필드

  const MyPageScreen({super.key, required this.userId});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final ApiService _apiService = ApiService(); // ApiService 인스턴스
  MypageModel? _user; // 사용자 정보를 저장할 변수
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // 사용자 데이터 요청
  }

  Future<void> _fetchUserData() async {
    try {
      _user = await _apiService.fetchUserInfo(widget.userId);
      setState(() {
        _isLoading = false; // 로딩 완료
      });
    } catch (e) {
      // 오류 처리
      print('Failed to load user data: $e');
      setState(() {
        _isLoading = false; // 로딩 완료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart TimeTable!'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // 로딩 중 표시
            : Column(
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
                      _user?.name ?? '이름 로딩 중...',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('학과 : ${_user?.major ?? '로딩 중...'}'),
                  Text('학번 : ${_user?.std_id ?? '로딩 중...'}'),
                  Text('이메일 : ${_user?.email ?? '로딩 중...'}'),
                  Text('아이디 : ${_user?.id ?? '로딩 중...'}'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('학년 : ${_user?.grade ?? '로딩 중...'} 학년'),
                      Text('학기 : ${_user?.semester ?? '로딩 중...'} 학기'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MajorManageScreen(userId: widget.userId)),
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
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ElectiveManageScreen(userId: widget.userId)),
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
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
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
                  ElevatedButton(
                    onPressed: () {
                      // 회원탈퇴 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
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
    String? newGrade = _user?.grade; // 기존 학년으로 초기화
    String? newSemester = _user?.semester; // 기존 학기로 초기화

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
                value: null,
                hint: const Text('학년을 선택하세요'),
                items: ['1', '2', '3', '4'].map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    newGrade = value; // 선택한 값을 상태에 반영
                  });
                },
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: null,
                hint: const Text('학기를 선택하세요'),
                items: ['1', '2'].map((String semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    newSemester = value; // 선택한 값을 상태에 반영
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (newGrade != null && newSemester != null) {
                  try {
                    await _apiService.updateGradeSemester(
                        widget.userId, newGrade!, newSemester!);
                    // 성공적으로 업데이트 후 UI 업데이트
                    setState(() {
                      _user?.grade = newGrade!;
                      _user?.semester = newSemester!;
                    });
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  } catch (e) {
                    // 오류 처리
                    print('Failed to update grade and semester: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('수정에 실패했습니다. 다시 시도하세요.')),
                    );
                  }
                } else {
                  // 선택되지 않은 경우 오류 메시지
                  print('학년 또는 학기가 선택되지 않았습니다.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('학년과 학기를 선택하세요.')),
                  );
                }
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // 로그인 화면으로 이동
      (route) => false, // 모든 이전 화면 제거
    );
  }
}
