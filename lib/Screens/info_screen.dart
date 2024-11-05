import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/main_page.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Screens/timetable_add.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정보'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: 150, // 이미지 또는 로고의 높이 조정
              width: double.infinity, // 이미지를 화면 너비에 맞춤
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(
                  'https://jw4.mju.ac.kr/user/indexMain.action?command=&siteId=cs'),
              child: const Text('홈페이지 연결'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL('https://core-courses-website.com'),
              child: const Text('핵심교양 확인'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL('https://common-courses-website.com'),
              child: const Text('공통교양 확인'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _launchURL('https://curriculum-website.com'),
              child: const Text('학과별 커리큘럼'),
            ),
          ],
        ),
      ),
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
                          builder: (content) => const TimetableScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () {
                  // 수업 추가 버튼 클릭 시 동작
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => TimetableAdd()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.library_books_rounded),
                onPressed: () {
                  // 정보 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const InfoScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
                  // 프로필 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const MyPageScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
