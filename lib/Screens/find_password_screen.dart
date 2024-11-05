import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/login_screen.dart';

class FindPasswordScreen extends StatefulWidget {
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

  void _findPassword() {
    // 여기에 백엔드와 연결하는 로직을 추가합니다.
    // 예시 데이터 (실제 데이터와 비교하는 로직 필요)
    String correctId = '123456';
    String correctEmail = 'hong@example.com';
    String correctName = '홍길동';
    String correctStudentId = '20220001';
    String correctPassword = 'securePassword'; // 예시 비밀번호

    if (_userIdController.text == correctId &&
        _emailController.text == correctEmail &&
        _studentIdController.text == correctStudentId &&
        _nameController.text == correctName) {
      setState(() {
        _message = '비밀번호를 찾았습니다!';
        _password = correctPassword; // 비밀번호를 저장
        _showLoginButton = true; // 로그인 버튼 표시
      });
    } else {
      setState(() {
        _message = '일치하지 않습니다';
        _showLoginButton = false; // 로그인 버튼 숨김
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위아래 공간을 균등 배분
          children: [
            Column(
              children: [
                // 아이디 입력 필드
                Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: const Text(
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
                SizedBox(height: 20),

                // 이메일 입력 필드
                Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: const Text(
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
                SizedBox(height: 20),

                // 학번 입력 필드
                Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: const Text(
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
                SizedBox(height: 20),

                // 이름 입력 필드
                Align(
                  alignment: Alignment.centerLeft, // 왼쪽 정렬
                  child: const Text(
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
                SizedBox(height: 20),

                // 오류 메시지 표시
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),

                // 비밀번호 표시
                if (_showLoginButton) // 비밀번호 표시
                  Text(
                    '당신의 비밀번호는 $_password 입니다.',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                SizedBox(height: 20),
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
