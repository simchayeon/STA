import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
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

  // 전공 목록 가져오기
  Future<List<Major>> fetchMajors() async {
    _logger.info('Fetching majors...'); // 전공 목록 요청 시작 로그

    final response = await http.get(Uri.parse('$baseUrl/subjects/majors'));

    if (response.statusCode == 200) {
      String decodeBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodeBody);
      _logger.info('Majors fetched successfully: ${response.statusCode}');
      return jsonData.map((json) => Major.fromJson(json)).toList();
    } else {
      _logger.severe('Failed to fetch majors: ${response.statusCode}');
      throw Exception('Failed to load majors');
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
        'coreCourses': selectedCoreCourses,
        'commonCourses': selectedCommonCourses,
      }),
    );

    _logger.info(
        'Save Selected Majors Response: ${response.statusCode}'); // 응답 상태 코드 출력
    return response.statusCode == 200; // 성공 여부 반환
  }
}
