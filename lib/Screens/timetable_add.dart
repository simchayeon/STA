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
  Map<String, List<AddMajor>> _filteredRecommendedSubjects = {};

  Map<String, List<AddMajor>> _groupedRecommendedSubjects = {};

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

  // 추천과목을 이름별로 그룹화하는 메서드
  Map<String, List<AddMajor>> _groupRecommendedSubjects(
      Map<String, List<AddMajor>> recommendedsubjects) {
    Map<String, List<AddMajor>> grouped = {};
    // recommendedSubjects의 각 엔트리를 순회
    for (var entry in recommendedsubjects.entries) {
      // 각 엔트리의 value(List<AddMajor>)를 순회
      for (var subject in entry.value) {
        // name에서 괄호를 제거한 이름을 가져오기
        final subjectNameWithoutBrackets =
            _getSubjectNameWithoutBrackets(subject.name);

        // 해당 이름으로 그룹화
        if (!grouped.containsKey(subjectNameWithoutBrackets)) {
          grouped[subjectNameWithoutBrackets] = [];
        }
        grouped[subjectNameWithoutBrackets]!.add(subject);
      }
    }

    return grouped;
  }

  // 추천 과목 API에서 받은 데이터를 화면에 표시
  void _updateRecommendedSubjects(
      Map<String, List<AddMajor>> recommendedSubjects) {
    setState(() {
      _filteredRecommendedSubjects = recommendedSubjects;
      _groupedRecommendedSubjects =
          _groupRecommendedSubjects(recommendedSubjects);
    });
  }

// 추천 과목 데이터를 가져오는 메서드
  Future<void> _loadRecommendedSubjects(
      Future<Map<String, List<AddMajor>>> Function() fetchFunction) async {
    try {
      final recommendedSubjects = await fetchFunction();

      // 추천 과목이 없을 경우 처리
      if (recommendedSubjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('추천할 과목이 없습니다.')),
        );
      } else {
        _updateRecommendedSubjects(recommendedSubjects);
      }
    } catch (e) {
      print("Error loading recommended subjects: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추천 과목을 가져오는 데 실패했습니다.')),
      );
    }
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

// 시간 중복 검사 함수
  bool _checkTimeConflict(
      List<AddMajor> existingSubjects, String newDay, String newTimeRange) {
    for (final subject in existingSubjects) {
      final regex = RegExp(r"([\w가-힣]+)\((\d{4}-\d{4})\)");
      final match = regex.firstMatch(subject.classTime);
      if (match != null) {
        final existingDay = match.group(1)!;
        final existingTimeRange = match.group(2)!;

        if (existingDay == newDay) {
          // 시간 겹치는지 확인
          final existingTimes =
              existingTimeRange.split('-').map(int.parse).toList();
          final newTimes = newTimeRange.split('-').map(int.parse).toList();

          if (!(newTimes[1] <= existingTimes[0] ||
              newTimes[0] >= existingTimes[1])) {
            // 시간 범위가 겹침
            print("시간 겹침 발견: $existingDay, $existingTimeRange");
            return true;
          }
        }
      }
    }
    return false; // 겹치지 않음
  }

// 특정 시간 문자열이 겹치는지 확인하는 함수
  bool _isTimeOverlap(
      String day1, String timeRange1, String day2, String timeRange2) {
    if (day1 != day2) {
      print("요일이 다릅니다: $day1 vs $day2");
      return false; // 요일이 다르면 겹치지 않음
    }

    // 시간 범위를 파싱
    final start1 = int.parse(timeRange1.split('-')[0]); // 시작 시간 (예: 1500)
    final end1 = int.parse(timeRange1.split('-')[1]); // 종료 시간 (예: 1750)
    final start2 = int.parse(timeRange2.split('-')[0]);
    final end2 = int.parse(timeRange2.split('-')[1]);

    print("시간 비교: $start1-$end1 vs $start2-$end2");

    // 시간이 겹치는지 확인
    return !(end1 <= start2 || start1 >= end2); // 겹치면 true
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
  Future<void> _addSubject() async {
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('추가할 과목을 선택하세요.')),
      );
      print("과목이 선택되지 않음");
      return;
    } else {
      // _selectedSubject의 정보를 출력
      print(
          "Selected Subject: ${_selectedSubject!.name}"); /*
    print("Class Time: ${_selectedSubject!.classTime}");
    print("Professor: ${_selectedSubject!.professor}");
    print("Lecture Number: ${_selectedSubject!.lectureNumber}");*/
    }

    // 사용자 선택 과목의 요일 및 시간 범위 추출
    final regex = RegExp(r"([\w가-힣]+)\((\d{4}-\d{4})\)");
    print("Raw classTime: '${_selectedSubject!.classTime}'");

    final match = regex.firstMatch(_selectedSubject!.classTime);
    if (match == null) {
      print("정규식 매칭 실패. 확인 필요: '${_selectedSubject!.classTime}'");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('선택한 과목의 시간 정보가 잘못되었습니다.')),
      );
      return;
    }

    final newDay = match.group(1)!; // 요일 (예: "화")
    final newTimeRange = match.group(2)!; // 시간 범위 (예: "1500-1750")

    print(
        "Processing class: ${_selectedSubject!.name}, Day: $newDay, Time Range: $newTimeRange");

    try {
      // 기존 과목 목록 가져오기
      List<dynamic> existingSubjects = await _controller.fetchSubjects() ?? [];
      print(
          "Fetched subjects from api: ${existingSubjects.map((s) => s.classTime).toList()}");

      // 중복 시간 확인
      bool hasConflict = existingSubjects.any((subject) {
        final existingMatch = regex.firstMatch(subject.classTime);
        print("여기까지는 됨");
        if (existingMatch != null) {
          final existingDay = existingMatch.group(1)!;
          final existingTimeRange = existingMatch.group(2)!;
          print("여기두개까지도 됨");

          // 시간이 겹치는지 확인
          bool overlap = _isTimeOverlap(
              existingDay, existingTimeRange, newDay, newTimeRange);
          print(
              "Overlap check: $existingDay, $existingTimeRange vs $newDay, $newTimeRange -> $overlap");
          return overlap;
        }
        return false;
      });

      if (hasConflict) {
        print("시간 중복 발생: 과목 추가 안됨");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('시간이 중복됩니다. 다른 과목을 선택하세요.')),
        );
        return;
      }

      // 중복이 없으면 추가 진행
      await _addSubjectToBackend(_selectedSubject!);
      

      // 상태 업데이트
      setState(() {
        _filteredSubjects.add(_selectedSubject!);
        _groupedSubjects = _groupSubjects(_filteredSubjects);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('과목이 성공적으로 추가되었습니다.')),
      );

      Navigator.pop(context); // 이전 화면으로 이동
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('과목 추가 중 오류 발생: $e')),
      );
      print("과목 추가 실패: $e");
      print("Selected Subject: ${_selectedSubject!.name}");
      print("Raw classTime: '${_selectedSubject!.classTime}'");
    }
  }

  // 검색 버튼 클릭 시
  void _onSearchPressed() {
    setState(() {
      isSearchActive = true; // 검색 버튼 클릭 시 활성화
    });
    _filterSubjects(); // 검색 후 필터링
  }

// 추천 과목 리스트 위젯
  Widget _buildRecommendedSubjectsList() {
    return _groupedSubjects.isEmpty
        ? const Center(child: Text('추천 과목이 없습니다.'))
        : ListView.builder(
            itemCount: _groupedRecommendedSubjects.keys.length,
            itemBuilder: (context, index) {
              final subjectName =
                  _groupedRecommendedSubjects.keys.elementAt(index);
              final subjects = _groupedRecommendedSubjects[subjectName]!;
              return ExpansionTile(
                title: Text(subjectName),
                children: subjects.map((subject) {
                  return ListTile(
                    title: Text(subject.name),
                    subtitle:
                        Text('${subject.classTime}    ${subject.professor}'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(subject.name),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                }).toList(),
              );
            },
          );
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
              // 추천 버튼과 관련된 UI 수정
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final recommendedmajors =
                          await apiService.fetchRecommendedMajor(widget.userId);
                      setState(() {
                        _filteredSubjects = recommendedmajors;
                        _groupedSubjects = _groupSubjects(recommendedmajors);
                      });
                    },
                    child: const Text('추천전공'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final recommendedcommon = await apiService
                          .fetchRecommendedCommon(widget.userId);
                      setState(() {
                        _filteredSubjects = recommendedcommon;
                        _groupedSubjects = _groupSubjects(recommendedcommon);
                      });
                    },
                    child: const Text('추천공통교양'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final recommendedcore =
                          await apiService.fetchRecommendedCore(widget.userId);
                      setState(() {
                        _filteredSubjects = recommendedcore;
                        _groupedSubjects = _groupSubjects(recommendedcore);
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
                                subtitle: Text(
                                    '${subject.classTime}  ${subject.professor}'),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(subject.name),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                        subtitle:
                            Text('${subject.classTime}  ${subject.professor}'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(subject.name),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
