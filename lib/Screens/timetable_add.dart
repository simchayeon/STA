// 시간표 추가 페이지
import 'package:flutter/material.dart';

class TimetableAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Timetable!'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '과목명을 검색하세요',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 검색 버튼 동작
                  },
                  child: Text('검색'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 전공 버튼 동작
                },
                child: Text('전공'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 공통교양 버튼 동작
                },
                child: Text('공통교양'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 핵심교양 버튼 동작
                },
                child: Text('핵심교양'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 일반교양 버튼 동작
                },
                child: Text('일반교양'),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('전공 실기6(성악)'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.orange, // 선택된 아이콘 색상
        unselectedItemColor: Colors.grey, // 선택되지 않은 아이콘 색상
      ),
    );
  }
}
