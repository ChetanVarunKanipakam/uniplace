import '../services/candidate_service.dart';

class CandidateRepository {
  final CandidateService _service = CandidateService();

  Future<List<Map<String, dynamic>>> getCandidates(String jobId,String token) async {
    return await _service.fetchCandidates(jobId,token);
  }
}
