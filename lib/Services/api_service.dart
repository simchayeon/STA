import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:smarttimetable/models/addmajor_model.dart';
import 'package:smarttimetable/models/mypage_model.dart';
import 'package:smarttimetable/models/subject_model.dart';
import 'package:smarttimetable/models/elective_model.dart';
import 'package:smarttimetable/models/major_model.dart';
import 'package:smarttimetable/models/user_model.dart';
import 'package:smarttimetable/models/mj_stid_model.dart';
import 'package:smarttimetable/models/per_info_model.dart';

class ApiService {
  // 로거 초기화
  final Logger _logger = Logger('ApiService');

  // 백엔드 URL 설정
  static const String baseUrl =
      'https://6c16-117-17-163-57.ngrok-free.app'; // 기본 주소

  // 홈 화면 (메인 페이지) 정보 받는 메소드
  Future<List<Subject>> fetchCurrentSubjects(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/members/$userId/current-subjects'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      // JSON 데이터가 비어있는 경우 빈 리스트 반환
      if (jsonData.isEmpty) {
        return [];
      }

      return jsonData.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subjects');
    }
  }

  // 공모전 정보 가져오기
  Future<List<String>> fetchContestImages() async {
    _logger.info('Fetching contest images...'); // 공모전 이미지 요청 시작 로그

    final response =
        await http.get(Uri.parse('$baseUrl/information/information'));

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);

      // 응답이 리스트 형태일 경우
      List<dynamic> jsonData = json.decode(decodeBody);

      // 리스트가 올바른지 확인하고 변환
      return List<String>.from(jsonData);
    } else {
      _logger.severe('Failed to fetch contest images: ${response.statusCode}');
      throw Exception('Failed to load contest images');
    }
  }

  // 사용자 정보 받는 메소드
  Future<MypageModel> fetchUserInfo(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/members/$userId/myPage'));

    if (response.statusCode == 200) {
      // 응답 바디를 UTF-8로 디코딩
      String responseBody = utf8.decode(response.bodyBytes);
      print('Response body: $responseBody'); // 응답 본문 로그 출력

      // JSON 파싱
      final jsonData = json.decode(responseBody);
      return MypageModel.fromJson(jsonData);
    } else {
      _logger.severe('Failed to load user info: ${response.statusCode}');
      throw Exception('Failed to load user info');
    }
  }

  // 학번, 학년 수정 메소드
  Future<void> updateGradeSemester(
      String userId, String grade, String semester) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/$userId/manageGradeSemester'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'grade': grade,
        'semester': semester,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update grade and semester: ${response.statusCode}');
    }
  }

  // 아이디, 전공 및 학번 정보를 제출하는 메소드
  Future<bool> submitMajorInfo(MajorInfo majorInfo) async {
    _logger.info('Submitting major info...'); // 요청 시작 로그

    // 요청 데이터 확인
    _logger.info('Request Data:');
    _logger.info('ID: ${majorInfo.id}');
    _logger.info('Major: ${majorInfo.major}');
    _logger.info('Student ID: ${majorInfo.student_id}');

    final response = await http.post(
      Uri.parse('$baseUrl/members/sign'), // 전공 정보 제출 엔드포인트
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'id': majorInfo.id, // 아이디
        'major': majorInfo.major, // 학과
        'student_id': majorInfo.student_id, // 학번
        'grade': majorInfo.grade,
        'semester': majorInfo.semester,
      }),
    );

    _logger.info('Major Info Response: ${response.statusCode}'); // 응답 상태 코드 출력
    _logger.info('Response Body: ${response.body}'); // 응답 본문 출력

    return response.statusCode == 200; // 성공 여부 반환
  }

  // 회원가입 메소드
  Future<bool> signUp(SignUp signUp, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/$userId/sign_IDPW'), // 회원가입 엔드포인트 수정
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'password': signUp.password, // 사용자 비밀번호
        'email': signUp.email, // 사용자 이메일
        'name': signUp.name, // 사용자 이름
      }),
    );

    _logger.info('Sign Up Response: ${response.statusCode}'); // 응답 상태 코드 출력
    _logger.info('Response Body: ${response.body}'); // 응답 본문 출력

    return response.statusCode == 200; // 회원가입 성공 여부 반환
  }

  // 로그인 메소드
  Future<bool> login(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/members/login'), // 로그인 엔드포인트 수정
      headers: {
        'Content-Type': 'application/json', // 요청 데이터 형식
      },
      body: jsonEncode({
        'id': user.id,
        'password': user.password, // 비밀번호
      }),
    );

    _logger.info('Login Response: ${response.statusCode}'); // 응답 상태 코드 출력
    return response.statusCode == 200; // 로그인 성공 여부 반환
  }


// (영빈) 시간표 수정화면에서 전공 목록 가져오기
  Future<List<AddMajor>> fetchAddMajors() async {
    _logger.info('Fetching addMajors...'); // 전공 목록 요청 시작 로그

    final response = await http.get(
      Uri.parse('$baseUrl/subjects/majors'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodeBody); // JSON 리스트 파싱
      _logger.info('AddMajors fetched successfully: ${response.statusCode}');
      return AddMajor.fromJsonList(jsonData); // 리스트 변환
    } else {
      _logger.severe('Failed to fetch addMajors: ${response.statusCode}');
      throw Exception('Failed to load addMajors');
    }
  }

// (영빈) 시간표 수정화면에서 핵심교양 목록 가져오기
  Future<List<AddMajor>> fetchCore() async {
    _logger.info('Fetching addMajors...'); // 전공 목록 요청 시작 로그

    final response = await http.get(
      Uri.parse('$baseUrl/subjects/coreElectives'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodeBody); // JSON 리스트 파싱
      _logger.info('core fetched successfully: ${response.statusCode}');
      return AddMajor.fromJsonList(jsonData); // 리스트 변환
    } else {
      _logger.severe('Failed to fetch core: ${response.statusCode}');
      throw Exception('Failed to load core');
    }
  }

  // (영빈) 시간표 수정화면에서 공통교양 목록 가져오기
  Future<List<AddMajor>> fetchCommon() async {
    _logger.info('Fetching addMajors...'); // 전공 목록 요청 시작 로그

    final response = await http.get(
      Uri.parse('$baseUrl/subjects/commonElectives'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodeBody); // JSON 리스트 파싱
      _logger.info('common fetched successfully: ${response.statusCode}');
      return AddMajor.fromJsonList(jsonData); // 리스트 변환
    } else {
      _logger.severe('Failed to fetch common: ${response.statusCode}');
      throw Exception('Failed to load common');
    }
  }



  // 전공 목록 가져오기
  Future<List<Major>> fetchMajors() async {
    _logger.info('Fetching majors...'); // 전공 목록 요청 시작 로그

    final response = await http.get(Uri.parse('$baseUrl/subjects/allMajors'));

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<String> jsonData =
          List<String>.from(json.decode(decodeBody)); // 문자열 리스트로 변환
      _logger.info('Majors fetched successfully: ${response.statusCode}');

      // Major 객체로 변환
      return jsonData.map((name) => Major(name: name)).toList();
    } else {
      _logger.severe('Failed to fetch majors: ${response.statusCode}');
      throw Exception('Failed to load majors');
    }
  }

  // 사용자가 선택한 전공 과목 가져오는 메소드
  Future<List<String>> fetchCompletedMajors(String userId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/members/$userId/completedCourseHistoryManagementMajor'));

    if (response.statusCode == 200) {
      // 응답 바디를 UTF-8로 디코딩
      String decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody'); // 응답 로그 출력

      List<dynamic> jsonData = json.decode(decodedBody);
      return List<String>.from(jsonData); // 전공 과목 이름 리스트 반환
    } else {
      print('Error: ${response.statusCode} - ${response.body}'); // 에러 로그 출력
      throw Exception('Failed to load completed majors');
    }
  }

  // 전공 과목 선택 저장하기
  Future<bool> saveSelectedMajors(
      String userId, List<String> selectedMajors) async {
    _logger
        .info('Saving selected majors for user: $userId'); // 선택된 전공 저장 요청 시작 로그

    final response = await http.post(
      Uri.parse('$baseUrl/members/$userId/sign_majorCourses'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'majors': selectedMajors}), // JSON 형태로 전송
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // 공통 교양 목록 가져오기
  Future<List<ElectiveCourse>> fetchCommonElectives() async {
    _logger.info('Fetching common electives...'); // 공통 교양 목록 요청 시작 로그

    final response =
        await http.get(Uri.parse('$baseUrl/subjects/commonElectives'));

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodeBody);
      _logger.info(
          'Common electives fetched successfully: ${response.statusCode}');
      return jsonData.map((json) => ElectiveCourse.fromJson(json)).toList();
    } else {
      _logger
          .severe('Failed to fetch common electives: ${response.statusCode}');
      throw Exception('Failed to load common electives');
    }
  }

  // 핵심 교양 목록 가져오기
  Future<List<ElectiveCourse>> fetchCoreElectives() async {
    _logger.info('Fetching core electives...'); // 핵심 교양 목록 요청 시작 로그

    final response =
        await http.get(Uri.parse('$baseUrl/subjects/coreElectives'));

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodeBody);
      _logger
          .info('Core electives fetched successfully: ${response.statusCode}');
      return jsonData.map((json) => ElectiveCourse.fromJson(json)).toList();
    } else {
      _logger.severe('Failed to fetch core electives: ${response.statusCode}');
      throw Exception('Failed to load core electives');
    }
  }

  // 선택한 교양 과목 저장하기
  Future<bool> saveSelectedElectives(
      String userId,
      List<String> selectedCoreCourses,
      List<String> selectedCommonCourses) async {
    _logger.info(
        'Saving selected electives for user: $userId'); // 선택된 교양 저장 요청 시작 로그

    final response = await http.post(
      Uri.parse('$baseUrl/members/$userId/sign_elective'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'coreElectives': selectedCoreCourses,
        'commonElectives': selectedCommonCourses,
      }),
    );

    _logger.info(
        'Save Selected Majors Response: ${response.statusCode}'); // 응답 상태 코드 출력
    return response.statusCode == 200; // 성공 여부 반환
  }

  // 사용자가 선택한 공통 교양 과목 가져오는 메소드
  Future<List<String>> fetchCompletedCommon(String userId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/members/$userId/completedCourseHistoryManagementCommon'));

    if (response.statusCode == 200) {
      // 응답 바디를 UTF-8로 디코딩
      String decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody'); // 응답 로그 출력

      // 응답이 비어 있는 경우 빈 리스트 반환
      if (decodedBody.isEmpty) {
        return []; // 빈 리스트 반환
      }
      try {
        List<dynamic> jsonData = json.decode(decodedBody);
        return List<String>.from(jsonData); // 교양 과목 이름 리스트 반환
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception('Failed to parse completed common courses');
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}'); // 에러 로그 출력
      throw Exception('Failed to load completed majors');
    }
  }

  // 사용자가 선택한 핵심 교양 과목 가져오는 메소드
  Future<List<String>> fetchCompletedCore(String userId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/members/$userId/completedCourseHistoryManagementCore'));

    if (response.statusCode == 200) {
      // 응답 바디를 UTF-8로 디코딩
      String decodedBody = utf8.decode(response.bodyBytes);
      print('Response body: $decodedBody'); // 응답 로그 출력

      // 응답이 비어 있는 경우 빈 리스트 반환
      if (decodedBody.isEmpty) {
        return []; // 빈 리스트 반환
      }
      try {
        List<dynamic> jsonData = json.decode(decodedBody);
        return List<String>.from(jsonData); // 교양 과목 이름 리스트 반환
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception('Failed to parse completed core courses');
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}'); // 에러 로그 출력
      throw Exception('Failed to load completed majors');
    }
  }

  // 아이디 찾기 메소드
  Future<String> findUserId(String studentId, String name, String email) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/members/findId?student_id=$studentId&name=$name&email=$email'), // GET 요청으로 변경
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response body: ${response.body}'); // 응답 본문 출력

    if (response.statusCode == 200) {
      // 서버가 텍스트 형식으로 응답하는 경우
      String responseBody = response.body;

      // 텍스트 형식에서 ID를 추출하는 로직을 추가해야 합니다.
      // 예를 들어, 응답이 "아이디: 123456" 형태라면
      RegExp regex = RegExp(r'아이디:\s*(\S+)');
      Match? match = regex.firstMatch(responseBody);

      if (match != null) {
        String userId = match.group(1)!; // 첫 번째 그룹에서 사용자 ID 추출
        print('Extracted User ID: $userId'); // 추출된 ID 출력
        return userId; // 사용자 ID 반환
      } else {
        throw Exception('Failed to find user ID in response: $responseBody');
      }
    } else {
      _logger.severe(
          'Failed to load user ID: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to find user ID: ${response.body}'); // 에러 메시지 개선
    }
  }

  // 비밀번호 찾기 메소드
  Future<String> findPassword(
      String userId, String email, String studentId, String name) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/members/findPassword?id=$userId&email=$email&student_id=$studentId&name=$name'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response body: ${response.body}'); // 응답 본문 출력

    if (response.statusCode == 200) {
      // 서버가 텍스트 형식으로 응답하는 경우
      String responseBody = response.body;

      // 텍스트 형식에서 비밀번호를 추출하는 로직을 추가해야 합니다.
      RegExp regex = RegExp(r'비밀번호:\s*(\S+)');
      Match? match = regex.firstMatch(responseBody);

      if (match != null) {
        String password = match.group(1)!; // 첫 번째 그룹에서 비밀번호 추출
        print('Extracted Password: $password'); // 추출된 비밀번호 출력
        return password; // 비밀번호 반환
      } else {
        throw Exception('Failed to find password in response: $responseBody');
      }
    } else {
      _logger.severe(
          'Failed to load password: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to find password: ${response.body}'); // 에러 메시지 개선
    }
  }

  // 아이디 중복 확인
  Future<bool> checkIdExists(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/members/checkId?id=$userId'));

    if (response.statusCode == 200) {
      // 서버에서 사용 가능한 아이디 메시지를 반환
      //return response.body == "사용 가능한 아이디입니다."; // 응답 메시지 확인
      return false;
    } else if (response.statusCode == 409) {
      // 아이디가 이미 존재하는 경우
      return true; // 이미 존재하는 아이디
    } else {
      throw Exception('아이디 중복 확인 실패');
    }
  }

  // 회원 탈퇴
  Future<void> withdrawMembership(String userId) async {
    final response = await http
        .delete(Uri.parse('$baseUrl/members/$userId/withdrawalOfMembership'));

    if (response.statusCode == 204) {
      // 탈퇴 성공
      return;
    } else if (response.statusCode == 404) {
      throw Exception('회원이 존재하지 않습니다.');
    } else {
      throw Exception('회원 탈퇴 실패: ${response.statusCode}');
    }
  }
}
