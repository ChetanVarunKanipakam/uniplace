import 'package:flutter/material.dart';
import '../data/repositories/schedule_repository.dart';
import '../state/auth_provider.dart';
import 'package:provider/provider.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository _repo = ScheduleRepository();

  List<Map<String, dynamic>> _schedules = [];
  bool _loading = false;

  List<Map<String, dynamic>> get schedules => _schedules;
  bool get loading => _loading;

  Future<void> loadSchedules(String companyId,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    _loading = true;
    notifyListeners();
    try {
      _schedules = await _repo.getSchedules(companyId,token);
    } catch (_) {
      _schedules = [];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addSchedule(Map<String, dynamic> data,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    await _repo.addSchedule(data,token);
    await loadSchedules(data["companyId"],context);
  }
}
