import 'package:flutter/material.dart';
import 'package:smarttimetable/controllers/login_controller.dart';
import 'package:smarttimetable/models/user_model.dart';
import 'main_page.dart';
import 'signup_screen.dart';
import 'find_id_screen.dart';
import 'find_password_screen.dart';

// 로그인 화면을 나타내는 StatelessWidget 클래스
class LoginPage extends StatelessWidget {
  LoginPage({super.key}); // const 생성자 추가

  final LoginController _loginController = LoginController(); // 로그인 컨트롤러 인스턴스 생성

  @override
  Widget build(BuildContext context) {
    // ID와 비밀번호 입력을 위한 텍스트 필드 컨트롤러
    final TextEditingController idController = TextEditingController(); // ID 입력 필드
    final TextEditingController passwordController = TextEditingController(); // 비밀번호 입력 필드

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'), // 앱 바 제목
        backgroundColor: Colors.orange, // 앱 바 색상
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 패딩
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중심 정렬
          children: [
            const Logo(), // 로고 위젯
            const SizedBox(height: 20), // 위젯 간 간격
            TextField(
              controller: idController, // ID 필드에 텍스트 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: 'ID', // 라벨 텍스트
                border: OutlineInputBorder(), // 테두리 스타일
              ),
            ),
            const SizedBox(height: 16), // 위젯 간 간격
            TextField(
              controller: passwordController, // 비밀번호 필드에 텍스트 컨트롤러 연결
              decoration: const InputDecoration(
                labelText: 'Password', // 라벨 텍스트
                border: OutlineInputBorder(), // 테두리 스타일
              ),
              obscureText: true, // 비밀번호 입력 시 텍스트 숨김
            ),
            const SizedBox(height: 16), // 위젯 간 간격
            const ForgotPassword(), // 비밀번호 찾기 및 회원가입 링크
            const SizedBox(height: 20), // 위젯 간 간격
            LoginButton(
              onPressed: () {
                onNext(context, idController, passwordController);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 로그인 처리 로직
  Future<void> onNext(BuildContext context, TextEditingController idController,
      TextEditingController passwordController) async {
    // 입력된 ID와 비밀번호를 사용하여 User 모델 생성
    User user = User(
      id: idController.text.trim(), // ID 입력 필드에서 텍스트 가져오기
      password: passwordController.text.trim(), // 비밀번호 입력 필드에서 텍스트 가져오기
    );

    // 로그인 시도
    bool success = await _loginController.login(user); // 로그인 로직 호출

    if (success) {
      // 로그인 성공 시 메인 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TimetableScreen()), // 메인 페이지로 이동
      );
    } else {
      // 로그인 실패 시 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패: 아이디 또는 비밀번호를 확인하세요.')),
      );
    }
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key}); // 'key'를 부모 클래스에 전달

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.stars_rounded, size: 100, color: Colors.orange),
        SizedBox(width: 8),
        Text(
          'STA',
          style: TextStyle(
            fontSize: 36,
            color: Colors.orange,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key}); // 'key'를 부모 클래스에 전달

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FindIDScreen()),
            );
          },
          child: const Text(
            '아이디 찾기',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FindPasswordScreen()),
            );
          },
          child: const Text('비밀번호 찾기', style: TextStyle(color: Colors.blue)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          child: const Text('회원가입', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed; // 버튼 클릭 시 호출할 콜백 함수

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // 버튼 너비를 최대화
      child: ElevatedButton(
        onPressed: onPressed, // 콜백 함수 호출
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // 버튼 배경색
          padding: const EdgeInsets.symmetric(vertical: 18.0), // 버튼 패딩
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)), // 둥근 모서리
          ),
        ),
        child: const Text(
          'LOGIN', // 버튼 텍스트
          style: TextStyle(fontSize: 24, color: Colors.white), // 텍스트 스타일
        ),
      ),
    );
  }
}
