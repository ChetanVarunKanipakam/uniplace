import 'api_service.dart';
import 'package:dio/dio.dart';
class UserService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await _api.dio.post("/auth/register", data: data);
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    // print(data);
    final response = await _api.dio.post("/auth/login", data: data);
    // print("user response $response");
    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> getProfile(token) async {
    final response = await _api.dio.get(
      "/users/me",
      options: Options(headers: {"Authorization": "Bearer $token"}), // ✅ send token
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<String> uploadResume(String filePath,String token) async {
    FormData formData = FormData.fromMap({
      "resumeFile": await MultipartFile.fromFile(filePath, filename: "resume.pdf"),
    });
    final response = await _api.dio.post("/resumes/upload", data: formData,options: Options(headers: {"Authorization": "Bearer $token"}),);
    return response.data["resumeUrl"];
  }
}
