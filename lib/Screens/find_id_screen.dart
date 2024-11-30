import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/login_screen.dart';
import 'package:smarttimetable/Services/api_service.dart';

class FindIDScreen extends StatefulWidget {
  const FindIDScreen({super.key});

  @override
  _FindIDScreenState createState() => _FindIDScreenState();
}

class _FindIDScreenState extends State<FindIDScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _message = '';
  String _userId = ''; // 사용자 ID를 저장할 변수
  bool _showLoginButton = false; // 로그인 버튼 표시 여부
  final ApiService _apiService = ApiService(); // ApiService 인스턴스

  void _findId() async {
    setState(() {
      _message = ''; // 메시지 초기화
    });

    try {
      String id = await _apiService.findUserId(
        _studentIdController.text,
        _nameController.text,
        _emailController.text,
      );

      setState(() {
        _message = '성공했습니다!';
        _userId = id; // ID를 저장
        _showLoginButton = true; // 로그인 버튼 표시
      });
    } catch (e) {
      setState(() {
        _message = '일치하지 않습니다: $e'; // 오류 메시지에 예외 추가
        _showLoginButton = false; // 로그인 버튼 숨김
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ID 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위아래 공간을 균등 배분
          children: [
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
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
                const Align(
                  alignment: Alignment.centerLeft,
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
                const Align(
                  alignment: Alignment.centerLeft,
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
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                if (_showLoginButton)
                  Text(
                    '당신의 ID는 $_userId 입니다.',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                const SizedBox(height: 20),
              ],
            ),
            if (_showLoginButton)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _findId,
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
