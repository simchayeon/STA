import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/main_page.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Screens/timetable_add.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/services/api_service.dart'; // ApiService 임포트

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final ApiService _apiService = ApiService();
  List<String> _contestImages = []; // 공모전 이미지 URL 리스트

  @override
  void initState() {
    super.initState();
    _fetchContestImages(); // 공모전 이미지 요청
  }

  Future<void> _fetchContestImages() async {
    try {
      final images = await _apiService.fetchContestImages();
      setState(() {
        _contestImages = images;
      });
    } catch (e) {
      // 오류 처리
      print('Error fetching contest images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Timetable!'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 공모전 이미지 슬라이드
            _contestImages.isNotEmpty
                ? SizedBox(
                    height: 150,
                    child: PageView.builder(
                      itemCount: _contestImages.length + 1, // 이미지 개수 + 1 (버튼)
                      itemBuilder: (context, index) {
                        if (index < _contestImages.length) {
                          return Image.network(
                            _contestImages[index],
                            fit: BoxFit.cover,
                          );
                        } else {
                          return GestureDetector(
                            onTap: () {
                              // 공모전 홈페이지로 연결
                              _launchURL(
                                  'https://contest-website.com'); // 실제 URL로 변경
                            },
                            child: Container(
                              color: Colors.orange,
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                : const Center(child: CircularProgressIndicator()), // 로딩 중 표시
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              const TimetableScreen(userId: 'id')));
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
