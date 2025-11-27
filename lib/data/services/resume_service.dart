import 'package:dio/dio.dart';
import 'api_service.dart';

class ResumeService {
  final ApiService _api = ApiService();

  Future<String> uploadResume(String filePath) async {
    FormData formData = FormData.fromMap({
      "resumeFile": await MultipartFile.fromFile(filePath, filename: "resume.pdf"),
    });
    final response = await _api.dio.post("/resumes/upload", data: formData);
    return response.data["resumeUrl"];
  }
}
