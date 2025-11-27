import 'api_service.dart';
import "package:dio/dio.dart";
class ApplicationService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> applyToCompany(Map<String, dynamic> data,String token) async {
    final response =await _api.dio.post("/applications/apply", data: data,options: Options(headers: {"Authorization": "Bearer $token"}),);
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> updateApplicationStatus(String appId, String status) async {
    await _api.dio.put("/applications/$appId/status", data: {"status": status});
  }
}
