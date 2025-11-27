import 'package:flutter/material.dart';
import '../data/models/company_model.dart';
import '../data/repositories/company_repository.dart';
import '../state/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
class CompanyProvider extends ChangeNotifier {
  final CompanyRepository _repo = CompanyRepository();

  List<Company> _companies = [];
  bool _loading = false;

  List<Company> get companies => _companies;
  bool get loading => _loading;

  Future<void> loadCompanies() async {
    _loading = true;
    notifyListeners();
    try {
      _companies = await _repo.getCompanies();
    } catch (_) {
      _companies = [];
    }
    _loading = false;
    notifyListeners();
  }
  Future<String> uploadImage(File image,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    return await _repo.uploadImage(image,token);
  }


  Future<void> addCompany(Map<String, dynamic> data,BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    await _repo.addCompany(data,token);
    await loadCompanies();
  }

  Future<void> deleteCompany(String id, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    await _repo.deleteCompany(id,token);
    await loadCompanies();
  }
}
