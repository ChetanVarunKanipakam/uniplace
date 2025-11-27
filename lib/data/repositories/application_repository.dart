import '../services/application_service.dart';

class ApplicationRepository {
  final ApplicationService _service = ApplicationService();

  Future<Map<String,dynamic>> applyToCompany(Map<String, dynamic> data,String token) async {

    return await _service.applyToCompany(data,token);
  }

  Future<void> updateApplicationStatus(String appId, String status) async {
    await _service.updateApplicationStatus(appId, status);
  }
}
