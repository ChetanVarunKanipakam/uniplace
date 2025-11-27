import 'package:flutter/material.dart';
import '../data/repositories/test_repository.dart';

class TestProvider extends ChangeNotifier {
  final TestRepository _repo = TestRepository();

  Map<String, dynamic>? _test;
  int _score = 0;

  Map<String, dynamic>? get test => _test;
  int get score => _score;

  Future<void> fetchTest(String testId) async {
    _test = await _repo.getTest(testId);
    notifyListeners();
  }

  Future<void> submitTest(String testId, String studentId, List<String> answers) async {
    final result = await _repo.submitTest(testId, studentId, answers);
    _score = result["score"];
    notifyListeners();
  }
}
