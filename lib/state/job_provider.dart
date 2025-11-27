import 'package:flutter/material.dart';
import '../data/models/job_model.dart';
import '../data/repositories/job_repository.dart';
import 'package:university_placement_app/state/auth_provider.dart';
import 'package:provider/provider.dart';
class JobProvider extends ChangeNotifier {
  final JobRepository _repo = JobRepository();

  List<Job> _jobs = [];
  bool _loading = false;

  List<Job> get jobs => _jobs;
  bool get loading => _loading;

  Future<void> loadJobsByCompany(String companyId) async {
    _loading = true;
    
    notifyListeners();
    try {
      _jobs = await _repo.getJobs(companyId);
    } catch (_) {
      _jobs = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addJob(Map<String, dynamic> data,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    await _repo.postJob(data,token);
    // await loadJobsByCompany(companyId);
  }
}
