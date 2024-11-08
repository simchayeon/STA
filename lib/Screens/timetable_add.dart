import 'package:flutter/material.dart';
import 'package:smarttimetable/Screens/info_screen.dart';
import 'package:smarttimetable/Screens/mypage_screen.dart';
import 'package:smarttimetable/Screens/timetable_add.dart';

class TimetableAdd extends StatefulWidget {
  const TimetableAdd({super.key});

  @override
  _TimetableAddState createState() => _TimetableAddState();
}

class _TimetableAddState extends State<TimetableAdd> {
  final List<String> _searchOptions = [
    '과목명으로 검색',
    '교강사명으로 검색',
    '강좌번호로 검색',
  ];
  String _selectedSearchOption = '과목명으로 검색'; // 기본 선택값 설정
  String _searchText = ''; // 검색어 저장 변수

  // 전체 과목 리스트
  final List<String> _subjects = [
    '전공 실기6(성악)',
    '전공 실기5(피아노)',
    '전공 실기4(기타)',
    '컴퓨터 보안'
  ];

  // 검색 결과 리스트
  List<String> _filteredSubjects = [];

  @override
  void initState() {
    super.initState();
    _filteredSubjects = _subjects; // 초기 상태로 전체 리스트를 표시
  }

  void _filterSubjects(String query) {
    setState(() {
      _searchText = query;
      _filteredSubjects =
          _subjects.where((subject) => subject.contains(query)).toList();
    });
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
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '과목명을 검색하세요',
                    ),
                    onChanged: (value) {
                      _filterSubjects(value);
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
                    });
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _filterSubjects(_searchText);
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryOptionsScreen(
                        category: '전공',
                        options: ['컴퓨터공학과', '전자공학과'],
                      ),
                    ),
                  );
                },
                child: const Text('전공'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryOptionsScreen(
                        category: '공통교양',
                        options: ['기독교', '사고와 표현', '언어', '진로와 디지털러시'],
                      ),
                    ),
                  );
                },
                child: const Text('공통교양'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryOptionsScreen(
                        category: '핵심교양',
                        options: ['역사와 철학', '사회와 공동체'],
                      ),
                    ),
                  );
                },
                child: const Text('핵심교양'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryOptionsScreen(
                        category: '일반교양',
                        options: ['말하기', '글쓰기'],
                      ),
                    ),
                  );
                },
                child: const Text('일반교양'),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: _filteredSubjects.map((subject) {
                return ListTile(
                  title: Text(subject),
                );
              }).toList(),
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
                          builder: (content) => const InfoScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
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
