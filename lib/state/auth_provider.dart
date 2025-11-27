import 'package:flutter/material.dart';
import '../data/repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _repo = UserRepository();

  bool _loading = false;
  String? _token;
  String? _error;
  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;
  bool get loading => _loading;
  String? get token => _token;
  String? get error => _error;

  Future<void> register(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _repo.register(data);
      _token = response["token"];
      _error = null;
    } catch (e) {
      _error = e.toString();
      _token = null;
    }
    _loading = false;
    notifyListeners();
  }

Future<void> login(Map<String, dynamic> data) async {
  _loading = true;
  _error = null; // Reset error on a new login attempt
  notifyListeners();
  try {
    final response = await _repo.login(data);
    _token = response["token"];
    _user = response["user"];
    _error = null;
  } catch (e) {
    _token = null; // Clear token on failure
    // Check for the specific "user not found" error from your repository/API.
    // NOTE: You must replace 'USER_NOT_FOUND' with the actual error code or message
    // your backend sends for this specific case.
    if (e.toString().contains('USER_NOT_FOUND')) {
      _error = 'No account found for that email. Please sign up.';
    } else {
      _error = 'User Not Found';
    }
    // Rethrow the error with our user-friendly message so the UI can catch it.
    throw Exception(_error);
  } finally {
    _loading = false;
    notifyListeners();
  }
}

  void logout() {
    _token = null;
    notifyListeners();
  }
}
