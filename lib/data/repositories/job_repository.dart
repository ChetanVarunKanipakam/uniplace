import '../models/job_model.dart';
import '../services/job_service.dart';

class JobRepository {
  final JobService _service = JobService();

  Future<void> postJob(Map<String, dynamic> data,String token) async {
    await _service.postJob(data,token);
  }

  Future<List<Job>> getJobs(String companyId) async {
    return await _service.fetchJobs(companyId);
  }
}
