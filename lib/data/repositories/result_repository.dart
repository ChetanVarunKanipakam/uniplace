import '../services/result_service.dart';

class ResultRepository {
  final ResultService _service = ResultService();

  Future<Map<String, dynamic>> getResults(String companyId,String token) async {
    return await _service.fetchResults(companyId,token);
  }
  Future<Map<String, dynamic>> getResultsForStudents(String token) async {
    return await _service.fetchResultsForStudents(token);
  }
  Future<void> publishResults(Map<String, dynamic> data,String token) async {
    await _service.publishResults(data,token);
  }
}
