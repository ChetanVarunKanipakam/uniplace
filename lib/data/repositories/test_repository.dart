import '../services/test_service.dart';

class TestRepository {
  final TestService _testService = TestService();

  Future<Map<String, dynamic>> getTest(String testId) async {
    return await _testService.getTest(testId);
  }

  Future<Map<String, dynamic>> submitTest(
      String testId, String studentId, List<String> answers) async {
    return await _testService.submitTest(testId, studentId, answers);
  }
}
