import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Services/api_service.dart';
import 'package:smarttimetable/models/addmajor_model.dart';

class Subject {
  final String id;
  final String name;

  Subject({
    required this.id,
    required this.name,
  });

  // Factory method to convert JSON into Subject object
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  // Convert Subject object to JSON for sending to the server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class TimetableAdd extends StatefulWidget {
  const TimetableAdd({super.key});

  @override
  _TimetableAddState createState() => _TimetableAddState();
}

class _TimetableAddState extends State<TimetableAdd> {
  final apiService = ApiService(); // ApiService 객체 생성

  // 검색 옵션
  final List<String> _searchOptions = [
    '과목명으로 검색',
    '교강사명으로 검색',
    '강좌번호로 검색',
  ];
  String _selectedSearchOption = '과목명으로 검색'; // 기본 선택값
  String _searchText = ''; // 검색어 저장 변수

  // 각 카테고리별 과목 리스트
  List<AddMajor> _majors = [];
  List<AddMajor> _coreElectives = [];
  List<AddMajor> _commonElectives = [];
  List<AddMajor> _filteredSubjects = []; // 화면에 보여줄 리스트
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
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '과목명을 검색하세요',
                    ),
                    onChanged: (value) {
                      //_filterSubjects(value);
                    },
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
                      //_filterSubjects(_searchText);
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    //_filterSubjects(_searchText);
                  },
                  child: const Text('검색'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final majors = await apiService.fetchAddMajors();
                  setState(() {
                    _filteredSubjects = majors;
                    print('UI 업데이트 - _filteredSubjects: $_filteredSubjects');
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
                  });
                },
                child: const Text('공통교양'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<AddMajor> coreElectives = await apiService.fetchCore();
                  setState(() {
                    _filteredSubjects = coreElectives;
                  });
                },
                child: const Text('핵심교양'),
              ),
            ],
          ),
          Expanded(
            child: _filteredSubjects.isEmpty
                ? const Center(child: Text('No subjects available.'))
                : ListView.builder(
                    itemCount: _filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = _filteredSubjects[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(
                            subject.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('강의 시간: ${subject.classTime}'),
                              Text('교수 이름: ${subject.professor}'),
                              Text('강의 번호: ${subject.lectureNumber}'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
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
                                        Text('교수 이름: ${subject.professor}'),
                                        Text('강의 번호: ${subject.lectureNumber}'),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('닫기'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
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
                          builder: (content) => const TimetableAdd()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const TimetableAdd()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.library_books_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const InfoScreen(
                                userId: '임시',
                              )));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const MyPageScreen(
                                userId: '임시',
                              )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryOptionsScreen extends StatefulWidget {
  final String category;
  final List<String> options;

  const CategoryOptionsScreen(
      {super.key, required this.category, required this.options});

  @override
  _CategoryOptionsScreenState createState() => _CategoryOptionsScreenState();
}

class _CategoryOptionsScreenState extends State<CategoryOptionsScreen> {
  List<String> selectedItems = [];

  void toggleSelection(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: ListView(
        children: widget.options.map((option) {
          return CheckboxListTile(
            title: Text(option),
            value: selectedItems.contains(option),
            onChanged: (_) => toggleSelection(option),
          );
        }).toList(),
      ),
    );
  }
}
