import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Services/api_service.dart';
import 'package:smarttimetable/controllers/timetable_controller.dart';
import 'package:smarttimetable/models/addmajor_model.dart';
import 'package:smarttimetable/Screens/main_page.dart';
//import 'package:key'

class TimetableAdd extends StatefulWidget {
  final String userId; // 사용자 ID를 받기 위한 필드

  const TimetableAdd({super.key, required this.userId});

  @override
  _TimetableAddState createState() => _TimetableAddState();
}

bool isSearchActive = false; // 검색 활성화 상태를 관리하는 변수

class _TimetableAddState extends State<TimetableAdd> {
  final apiService = ApiService(); // ApiService 객체 생성
  late TimetableController _controller; //타임테이블 컨트롤러 선언
  late List<AddMajor> _subjects; // 과목 목록
  late Map<String, List<AddMajor>> _groupedSubjects = {}; // 과목 그룹화
  AddMajor? _selectedSubject; // 선택한 과목

  // 검색 옵션
  final List<String> _searchOptions = [
    '과목명으로 검색',
    '교강사명으로 검색',
    '강좌번호로 검색',
  ];
  String _selectedSearchOption = '과목명으로 검색'; // 기본 선택값

  String _searchText = ''; // 검색어 저장 변수
  List<AddMajor> _filteredSubjects = []; // 화면에 보여줄 리스트

//Map<String, List<AddMajor>> _groupedSubjects = {};

  // 각 카테고리별 과목 리스트
  /*List<AddMajor> _majors = [];
  List<AddMajor> _coreElectives = [];
  List<AddMajor> _commonElectives = [];
  List<AddMajor> _filteredSubjects = []; // 화면에 보여줄 리스트
*/

  @override
  void initState() {
    super.initState();
    _loadAllSubjects(); // 초기화 시 전체 과목을 로드
    _controller = TimetableController(widget.userId);
  }

  // 전체 과목을 불러오는 메서드
  Future<void> _loadAllSubjects() async {
    try {
      final allSubjects =
          await apiService.fetchAllSubjects(); // 전체 과목 불러오는 API 호출
      setState(() {
        _subjects = allSubjects;
        _groupedSubjects = _groupSubjects(allSubjects); // 그룹화된 과목 리스트로 업데이트
        _filteredSubjects = allSubjects; // 전체 과목 리스트로 업데이트
      });
    } catch (e) {
      print("Error loading subjects: $e");
    }
  }

  // 과목 이름에서 괄호를 제외한 부분만 추출하는 메서드
  String _getSubjectNameWithoutBrackets(String name) {
    final regex = RegExp(r"\(.*\)"); // 괄호와 그 안의 내용을 찾는 정규식
    return name.replaceAll(regex, '').trim(); // 괄호 부분을 제거한 이름 반환
  }

  // 과목을 이름별로 그룹화하는 메서드
  Map<String, List<AddMajor>> _groupSubjects(List<AddMajor> subjects) {
    Map<String, List<AddMajor>> grouped = {};
    for (var subject in subjects) {
      final subjectNameWithoutBrackets =
          _getSubjectNameWithoutBrackets(subject.name);
      if (!grouped.containsKey(subjectNameWithoutBrackets)) {
        grouped[subjectNameWithoutBrackets] = [];
      }
      grouped[subjectNameWithoutBrackets]!.add(subject);
    }
    return grouped;
  }

//검색 필터링 메서드
  void _filterSubjects() {
    setState(() {
      if (_searchText.isEmpty) {
        _filteredSubjects = _subjects; //겁색어가 없으면 전체 과목을 보여줌
        _groupedSubjects = _groupSubjects(_subjects); // 그룹화
        isSearchActive = false; // 검색 비활성화
      } else {
        switch (_selectedSearchOption) {
          case '과목명으로 검색':
            _filteredSubjects = _subjects.where((subject) {
              return subject.name
                  .toLowerCase()
                  .contains(_searchText.toLowerCase());
            }).toList();
            break;
          case '교강사명으로 검색':
            _filteredSubjects = _subjects.where((subject) {
              return subject.professor
                  .toLowerCase()
                  .contains(_searchText.toLowerCase());
            }).toList();
            break;
          case '강좌번호로 검색':
            _filteredSubjects = _subjects.where((subject) {
              return subject.lectureNumber
                  .toLowerCase()
                  .contains(_searchText.toLowerCase());
            }).toList();
            break;
          default:
            _filteredSubjects = _subjects;
        }
        isSearchActive = true; // 검색 활성화
      }
      //_groupSubjects(); // 필터링 후 그룹화 수행
    });
  }

  // 검색 버튼 클릭 시 호출
  void _onSearchButtonPressed() {
    _filterSubjects(); // 필터링 실행
  }

// 과목 추가 요청을 보내는 메서드
  Future<void> _addSubjectToBackend(AddMajor subject) async {
    final url = Uri.parse(
        'https://ff08-2001-e60-929d-de4a-e598-237c-a4ed-93d7.ngrok-free.app/members/${widget.userId}/addToMember'); // 실제 API 주소 사용
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': subject.name,
          'classTime': subject.classTime,
          'professor': subject.professor,
          'lectureNumber': subject.lectureNumber,
        }),
      );
      if (response.statusCode == 200) {
        print('Subject added successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('과목이 성공적으로 추가되었습니다.')),
        );
      } else {
        print('Failed to add subject. Status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('과목 추가에 실패했습니다. 다시 시도하세요.')),
        );
      }
    } catch (e) {
      print('Error while adding subject: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오류가 발생했습니다.')),
      );
    }
  }

  // 과목 추가 버튼 클릭 시
  void _addSubject() {
    if (_selectedSubject != null) {
      _addSubjectToBackend(_selectedSubject!); // 백엔드에 추가 요청
      Navigator.pop(context, _selectedSubject); // 이전 화면으로 이동
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추가할 과목을 선택하세요.')),
      );
    }
  }

  // 검색 버튼 클릭 시
  void _onSearchPressed() {
    setState(() {
      isSearchActive = true; // 검색 버튼 클릭 시 활성화
    });
    _filterSubjects(); // 검색 후 필터링
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Timetable!'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '검색어를 입력하세요',
                    ),
                    onChanged: (value) {
                      _searchText = value;
                      _filterSubjects(); // 검색어 변경 시 필터링 적용
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedSearchOption,
                  items: _searchOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSearchOption = newValue!;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _filterSubjects,
                  child: const Text('검색'),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filteredSubjects = _subjects;
                        _groupedSubjects = _groupSubjects(_subjects);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) =>
                                  TimetableAdd(userId: widget.userId)));
                    },
                    child: const Text('전체과목'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final majors = await apiService.fetchAddMajors();
                      setState(() {
                        _filteredSubjects = majors;
                        _groupedSubjects = _groupSubjects(majors);
                      });
                    },
                    child: const Text('전공'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<AddMajor> commonElectives =
                          await apiService.fetchCommon();
                      setState(() {
                        _filteredSubjects = commonElectives;
                        _groupedSubjects = _groupSubjects(commonElectives);
                      });
                    },
                    child: const Text('공통교양'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<AddMajor> coreElectives =
                          await apiService.fetchCore();
                      setState(() {
                        _filteredSubjects = coreElectives;
                        _groupedSubjects = _groupSubjects(coreElectives);
                      });
                    },
                    child: const Text('핵심교양'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final recommededMajors =
                          await apiService.fetchRecommendedMajor(widget.userId);
                      setState(() {
                        _filteredSubjects = recommededMajors;
                        _groupedSubjects = _groupSubjects(recommededMajors);
                      });
                    },
                    child: const Text('추천전공'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final recommededCommon = await apiService
                          .fetchRecommendedCommon(widget.userId);
                      setState(() {
                        _filteredSubjects = recommededCommon;
                        _groupedSubjects = _groupSubjects(recommededCommon);
                      });
                    },
                    child: const Text('추천공통교양'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final recommededCore =
                          await apiService.fetchRecommendedCore(widget.userId);
                      setState(() {
                        _filteredSubjects = recommededCore;
                        _groupedSubjects = _groupSubjects(recommededCore);
                      });
                    },
                    child: const Text('추천핵심교양'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: (_searchText.isEmpty
                ? (_groupedSubjects.isEmpty
                    ? const Center(child: Text('과목이 없습니다.'))
                    : ListView.builder(
                        itemCount: _groupedSubjects.keys.length,
                        itemBuilder: (context, index) {
                          final subjectName =
                              _groupedSubjects.keys.elementAt(index);
                          final subjects = _groupedSubjects[subjectName]!;
                          return ExpansionTile(
                            title: Text(subjectName),
                            children: subjects.map((subject) {
                              return ListTile(
                                title: Text(subject.name),
                                subtitle: Text('강의 시간: ${subject.classTime}'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(subject.name),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('강의 시간: ${subject.classTime}'),
                                            Text('교수: ${subject.professor}'),
                                            Text(
                                                '강의 번호: ${subject.lectureNumber}'),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              _selectedSubject = subject;
                                              _addSubject();
                                            },
                                            child: const Text('과목추가'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            }).toList(),
                          );
                        },
                      ))
                : ListView.builder(
                    itemCount: _filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = _filteredSubjects[index];
                      return ListTile(
                        title: Text(subject.name),
                        subtitle: Text('강의 시간: ${subject.classTime}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(subject.name),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('강의 시간: ${subject.classTime}'),
                                    Text('교수: ${subject.professor}'),
                                    Text('강의 번호: ${subject.lectureNumber}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _selectedSubject = subject;
                                      _addSubject();
                                    },
                                    child: const Text('과목추가'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  )),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomAppBar(
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home_rounded),
                onPressed: () {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              TimetableAdd(userId: widget.userId)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.library_books_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              InfoScreen(userId: widget.userId)));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
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
}
