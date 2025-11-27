import '../services/resume_service.dart';

class ResumeRepository {
  final ResumeService _service = ResumeService();

  Future<String> uploadResume(String filePath) async {
    return await _service.uploadResume(filePath);
  }
}
