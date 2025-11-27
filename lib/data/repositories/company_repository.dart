import '../models/company_model.dart';
import '../services/company_service.dart';
import 'package:dio/dio.dart';
import '../services/api_service.dart';
import 'dart:io';

class CompanyRepository {
  final CompanyService _service = CompanyService();
  final ApiService _api = ApiService();
  Future<List<Company>> getCompanies() async {
    return await _service.fetchCompanies();
  }
  Future<String> uploadImage(File image, String token) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
    });

    final response = await _api.dio.post(
      '/companies/upload',
      data: formData,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return response.data['url'];
  }

  Future<void> addCompany(Map<String, dynamic> data,String token) async {
    await _service.addCompany(data,token);
  }

  Future<void> deleteCompany(String id,String token) async {
    await _service.deleteCompany(id,token);
  }
}
