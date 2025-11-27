import 'api_service.dart';
import 'package:dio/dio.dart';
class ScheduleService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> fetchSchedules(String companyId,String token) async {
    final response = await _api.dio.get("/schedules/$companyId",options: Options(headers: {"Authorization": "Bearer $token"}),);
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> addSchedule(Map<String, dynamic> data,String token) async {
    await _api.dio.post("/schedules", data: data,options: Options(headers: {"Authorization": "Bearer $token"}),);
  }
}
