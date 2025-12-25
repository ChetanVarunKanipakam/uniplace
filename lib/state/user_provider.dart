import 'package:flutter/material.dart';
import 'package:university_placement_app/state/auth_provider.dart';
import '../data/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'resume_provider.dart';
class UserProvider extends ChangeNotifier {
  final UserRepository _repo = UserRepository();
  Map<String, dynamic>? _profile;
  bool _loading = false;
  String? _token;
  Map<String, dynamic>? get profile => _profile;
  bool get loading => _loading;
  String? get token => _token;
  Future<void> fetchProfile(BuildContext context) async {
    _loading = true;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    // print(token);
    notifyListeners();
    try {
      _profile = await _repo.getProfile(token);
    } catch (e) {
      // print(e);
      _profile = null;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> uploadResume(String filePath,BuildContext context) async {
    try {
      _loading = true;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
      final token = authProvider.token;
      if (token == null) {
        throw Exception("User not authenticated");
      }
      final url = await _repo.uploadResume(filePath,token);
      _profile?["resumeUrl"] = url; // update profile with resume link
      resumeProvider.uploadResume(url);
      _profile = await _repo.getProfile(token);
      _loading=false;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
}
