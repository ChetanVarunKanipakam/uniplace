import '../services/user_service.dart';

class UserRepository {
  final UserService _service = UserService();

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return await _service.register(data);
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    return await _service.login(data);
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    return await _service.getProfile(token);
  }

  Future<String> uploadResume(String filePath,String token) async {
    return await _service.uploadResume(filePath,token);
  }
}
