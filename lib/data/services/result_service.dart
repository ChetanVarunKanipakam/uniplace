import 'api_service.dart';
import 'package:dio/dio.dart';
class ResultService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> fetchResults(String companyId,String token) async {
    final response = await _api.dio.get("/results/$companyId",options: Options(headers: {"Authorization": "Bearer $token"}),);
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> fetchResultsForStudents(String token) async {
    // print(token);
    final response = await _api.dio.get("/results/selects",options: Options(headers: {"Authorization": "Bearer $token"}),);
    // print(response);
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> publishResults(Map<String, dynamic> data,String token) async {
    await _api.dio.post("/results", data: data,options: Options(headers: {"Authorization": "Bearer $token"}),);
  }
}
