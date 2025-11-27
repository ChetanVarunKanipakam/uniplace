import '../services/schedule_service.dart';

class ScheduleRepository {
  final ScheduleService _service = ScheduleService();

  Future<List<Map<String, dynamic>>> getSchedules(String companyId,String token) async {
    return await _service.fetchSchedules(companyId,token);
  }

  Future<void> addSchedule(Map<String, dynamic> data,String token) async {
    await _service.addSchedule(data,token);
  }
}
