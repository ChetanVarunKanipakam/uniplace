import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeProvider extends ChangeNotifier {

  String? _resumeUrl;
  bool _uploading = false;

  String? get resumeUrl => _resumeUrl;
  bool get uploading => _uploading;

  ResumeProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _resumeUrl = prefs.getString("resumeUrl");
    notifyListeners();
  }

  Future<void> _saveToStorage(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("resumeUrl", url);
  }

  Future<void> uploadResume(String url) async {
    _uploading = true;
    notifyListeners();
    try {
      _resumeUrl = url;
      await _saveToStorage(url);
    } catch (e) {
      _resumeUrl = null;
    }
    _uploading = false;
    notifyListeners();
  }
}
