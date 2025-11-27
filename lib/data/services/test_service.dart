import 'package:dio/dio.dart';
import 'api_service.dart';

class TestService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getTest(String testId) async {
    try {
      final response = await _api.dio.get("/tests/$testId");
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to fetch test");
    }
  }

  Future<Map<String, dynamic>> submitTest(String testId, String studentId, List<String> answers) async {
    try {
      final response = await _api.dio.post(
        "/tests/submit/$testId",
        data: {"studentId": studentId, "answers": answers},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Failed to submit test");
    }
  }
}
