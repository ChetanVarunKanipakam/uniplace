import 'package:flutter/material.dart';
import '../data/repositories/application_repository.dart';
import 'package:university_placement_app/state/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
class ApplicationProvider extends ChangeNotifier {
  final ApplicationRepository _repo = ApplicationRepository();

  bool _applying = false;
  String? _statusMessage;

  bool get applying => _applying;
  String? get statusMessage => _statusMessage;

  Future<void> apply(BuildContext context, Map<String, dynamic> data) async {
    _applying = true;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }

    try {
      final response =await _repo.applyToCompany(data, token);

      _statusMessage = response['message'];
    } on DioException catch (e) {
      // Handle specific backend errors, like "Already Applied"
      if (e.response?.data != null && e.response?.data['message'] != null) {
        _statusMessage = e.response!.data['message'];
      } else {
        _statusMessage = "An unexpected error occurred. Please try again.";
      }
      // Throw the user-friendly message so the UI can display it
      throw Exception(_statusMessage);

    } catch (e) {
      _statusMessage = "An unexpected error occurred.";
      throw Exception(_statusMessage);
    } finally {
      _applying = false;
      notifyListeners();
    }
 // only once
  }


  Future<void> updateStatus(String appId, String status) async {
    try {
      await _repo.updateApplicationStatus(appId, status);
      _statusMessage = "Status updated";
    } catch (e) {
      _statusMessage = "Error: $e";
    }
    notifyListeners();
  }
}
