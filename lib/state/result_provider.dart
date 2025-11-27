import 'package:flutter/material.dart';
import '../data/repositories/result_repository.dart';
import '../state/auth_provider.dart';
import 'package:provider/provider.dart';
class ResultProvider extends ChangeNotifier {
  final ResultRepository _repo = ResultRepository();

  Map<String, dynamic>? _result;
  bool _loading = false;

  Map<String, dynamic>? get result => _result;
  bool get loading => _loading;

  Future<void> fetchResults(String companyId,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    _loading = true;
    notifyListeners();
    try {
      _result = await _repo.getResults(companyId,token);
    } catch (_) {
      _result = null;
    }
    _loading = false;
    notifyListeners();
  }
  
  Future<void> fetchResultsForStudents(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    _loading = true;
    notifyListeners();
    try {
      _result = await _repo.getResultsForStudents(token);
    } catch (_) {
      _result = null;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> publishResults(Map<String, dynamic> data,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    await _repo.publishResults(data,token);
    await fetchResults(data["companyId"],context);
  }
}
