import '../models/company_model.dart';
import 'api_service.dart';
import 'package:dio/dio.dart';

class CompanyService {
  final ApiService _api = ApiService();

  Future<List<Company>> fetchCompanies() async {
    final response = await _api.dio.get("/companies");
    return (response.data as List).map((json) => Company.fromJson(json)).toList();
  }

  Future<void> addCompany(Map<String, dynamic> data,String token) async {
    await _api.dio.post("/companies", data: data,options: Options(headers: {"Authorization": "Bearer $token"}),);
  }

  Future<void> deleteCompany(String id,String token) async {
    await _api.dio.delete("/companies/$id",options: Options(headers: {"Authorization": "Bearer $token"}),);
  }
}
