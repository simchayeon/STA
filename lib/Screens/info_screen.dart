import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/main_page.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Screens/timetable_add.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/Services/api_service.dart'; // ApiService 임포트

class InfoScreen extends StatefulWidget {
  final String userId; // 사용자 ID를 받기 위한 필드

  const InfoScreen({super.key, required this.userId});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final ApiService _apiService = ApiService();
  List<String> _contestImages = []; // 공모전 이미지 URL 리스트
  final PageController _pageController = PageController(); // 페이지 컨트롤러 추가

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

  void _nextPage() {
    if (_contestImages.isNotEmpty) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
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
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 350,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount:
                              _contestImages.length + 1, // 이미지 개수 + 1 (버튼)
                          itemBuilder: (context, index) {
                            if (index < _contestImages.length) {
                              return Image.network(
                                _contestImages[index],
                                fit: BoxFit.contain,
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  // 공모전 홈페이지로 연결
                                  _launchURL(
                                      'https://www.campuspick.com/contest'); // 실제 URL로 변경
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      color: Colors.orange,
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 10,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          // 왼쪽 화살표 클릭 시 이전 페이지로 이동
                                          if (_pageController.page!.toInt() >
                                              0) {
                                            _pageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        left: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.orange[100],
                          ),
                          onPressed: () {
                            // 왼쪽 화살표 클릭 시 이전 페이지로 이동
                            if (_pageController.page!.toInt() > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.orange[100],
                          ),
                          onPressed: _nextPage, // 오른쪽 화살표 클릭 시 다음 페이지로 이동
                        ),
                      ),
                    ],
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
              onPressed: () =>
                  _launchURL('https://www.mju.ac.kr/bangmok/1650/subview.do#'),
              child: const Text('핵심교양 확인'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  _launchURL('https://www.mju.ac.kr/bangmok/1649/subview.do'),
              child: const Text('공통교양 확인'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurriculumImageScreen(
                      imagePath:
                          '/Users/simchaeyeon/smarttimetable/assets/img/majors.png'),
                ),
              ),
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
                          builder: (content) => TimetableScreen(
                              userId: widget.userId))); // 사용자 ID 전달
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
                              ))); // 사용자 ID 전달
                },
              ),
              IconButton(
                icon: const Icon(Icons.library_books_rounded),
                onPressed: () {
                  // 정보 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              InfoScreen(userId: widget.userId))); // 사용자 ID 전달
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
                  // 프로필 버튼 클릭 시 동작
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MyPageScreen(
                              userId: widget.userId))); // 사용자 ID 전달
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

class CurriculumImageScreen extends StatelessWidget {
  final String imagePath;

  const CurriculumImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학과별 커리큘럼'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20.0),
          minScale: 0.5, // 최소 확대 배율
          maxScale: 4.0, // 최대 확대 배율
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.5, // 화면 너비의 80%
            height: MediaQuery.of(context).size.height * 1.5, // 화면 높이의 80%
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
