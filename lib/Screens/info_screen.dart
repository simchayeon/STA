import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // URL을 열기 위한 패키지 임포트

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key); // 생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정보 페이지'), // 앱 바 제목
        backgroundColor: Colors.orange, // 앱 바 색상
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 전체 Padding 설정
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            Container(
              height: 100, // 이미지 또는 로고의 높이
              width: 100, // 이미지 또는 로고의 너비
              color: Colors.grey[300], // Placeholder 배경 색상
            ),
            SizedBox(height: 20), // 위젯 간 간격
            ElevatedButton(
              onPressed: () => _launchURL('https://computer-science-website.com'), // 홈페이지 연결 버튼 클릭 시 URL 호출
              child: const Text('홈페이지 연결'), // 버튼 텍스트
            ),
            SizedBox(height: 16), // 위젯 간 간격
            ElevatedButton(
              onPressed: () => _launchURL('https://core-courses-website.com'), // 핵심 교양 확인 버튼 클릭 시 URL 호출
              child: const Text('핵심교양 확인'), // 버튼 텍스트
            ),
            SizedBox(height: 16), // 위젯 간 간격
            ElevatedButton(
              onPressed: () => _launchURL('https://common-courses-website.com'), // 공통 교양 확인 버튼 클릭 시 URL 호출
              child: const Text('공통교양 확인'), // 버튼 텍스트
            ),
            SizedBox(height: 16), // 위젯 간 간격
            ElevatedButton(
              onPressed: () => _launchURL('https://curriculum-website.com'), // 학과별 커리큘럼 버튼 클릭 시 URL 호출
              child: const Text('학과별 커리큘럼'), // 버튼 텍스트
            ),
          ],
        ),
      ),
    );
  }

  // URL을 열기 위한 함수
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) { // URL이 열 수 있는지 확인
      await launch(url); // URL 열기
    } else {
      throw 'Could not launch $url'; // 오류 처리
    }
  }
}
