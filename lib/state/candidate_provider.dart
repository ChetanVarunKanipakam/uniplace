import 'package:flutter/material.dart';
import '../data/repositories/candidate_repository.dart';
import 'package:provider/provider.dart';
import 'package:university_placement_app/state/auth_provider.dart';

class CandidateProvider extends ChangeNotifier {
  final CandidateRepository _repo = CandidateRepository();

  List<Map<String, dynamic>> _candidates = [];
  bool _loading = false;

  List<Map<String, dynamic>> get candidates => _candidates;
  bool get loading => _loading;

  Future<void> loadCandidates(String jobId,BuildContext context) async {
    _loading = true;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    notifyListeners();
    try {
      _candidates = await _repo.getCandidates(jobId,token);
    } catch (_) {
      _candidates = [];
    }
    _loading = false;
    notifyListeners();
  }
}
