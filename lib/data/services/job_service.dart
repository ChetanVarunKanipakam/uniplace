import '../models/job_model.dart';
import 'api_service.dart';
import 'package:dio/dio.dart';
class JobService {
  final ApiService _api = ApiService();

  Future<void> postJob(Map<String, dynamic> data,String token) async {
    await _api.dio.post("/jobs", data: data,options: Options(headers: {"Authorization": "Bearer $token"}),);
  }

  Future<List<Job>> fetchJobs(String companyId) async {
    print(companyId);
    final response = await _api.dio.get("/jobs/$companyId");
    return (response.data as List).map((json) => Job.fromJson(json)).toList();
  }
}
