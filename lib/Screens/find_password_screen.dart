import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/login_screen.dart';
import 'package:smarttimetable/services/api_service.dart';

class FindPasswordScreen extends StatefulWidget {
  const FindPasswordScreen({super.key});

  @override
  _FindPasswordScreenState createState() => _FindPasswordScreenState();
}

class _FindPasswordScreenState extends State<FindPasswordScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _message = '';
  String _password = ''; // 사용자 비밀번호를 저장할 변수
  bool _showLoginButton = false; // 로그인 버튼 표시 여부
  final ApiService _apiService = ApiService(); // ApiService 인스턴스

  void _findPassword() async {
    setState(() {
      _message = ''; // 메시지 초기화
    });

    try {
      String password = await _apiService.findPassword(
        _userIdController.text,
        _emailController.text,
        _studentIdController.text,
        _nameController.text,
      );

      setState(() {
        _message = '비밀번호를 찾았습니다!';
        _password = password; // 비밀번호를 저장
        _showLoginButton = true; // 로그인 버튼 표시
      });
    } catch (e) {
      setState(() {
        _message = '일치하지 않습니다'; // 오류 메시지
        _showLoginButton = false; // 로그인 버튼 숨김
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위아래 공간을 균등 배분
          children: [
            Column(
              children: [
                // 아이디 입력 필드
                const Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Text(
                    '아이디',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '아이디를 입력하세요',
                  ),
                ),
                const SizedBox(height: 20),

                // 이메일 입력 필드
                const Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Text(
                    '이메일',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '이메일을 입력하세요',
                  ),
                ),
                const SizedBox(height: 20),

                // 학번 입력 필드
                const Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Text(
                    '학번',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '학번을 입력하세요',
                  ),
                ),
                const SizedBox(height: 20),

                // 이름 입력 필드
                const Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: Text(
                    '이름',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '이름을 입력하세요',
                  ),
                ),
                const SizedBox(height: 20),

                // 오류 메시지 표시
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),

                // 비밀번호 표시
                if (_showLoginButton) // 비밀번호 표시
                  Text(
                    '당신의 비밀번호는 $_password 입니다.',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                const SizedBox(height: 20),
              ],
            ),

            // 로그인 화면으로 버튼
            if (_showLoginButton) // 로그인 버튼은 조건부로 표시
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 로그인 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 다른 색상으로 설정 가능
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    '로그인 화면으로',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // 다음 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _findPassword,
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
    );
  }
}
