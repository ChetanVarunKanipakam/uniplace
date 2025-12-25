import 'api_service.dart';
import "package:dio/dio.dart";

class CandidateService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> fetchCandidates(String jobId,String token) async {
    final response = await _api.dio.get("/candidates/$jobId",options: Options(headers: {"Authorization": "Bearer $token"}));
    // print(response.data);
    return List<Map<String, dynamic>>.from(response.data);
  }
}
