// lib/data/services/notification_service.dart

import '../models/notification_model.dart';
import 'api_service.dart';
import 'package:dio/dio.dart';
class NotificationService {
  final ApiService _api = ApiService();

  Future<List<NotificationModel>> fetchNotifications(String token) async {
    final response = await _api.dio.get("/notifications",options: Options(headers: {"Authorization": "Bearer $token"}));
    // Cast the response data to a list of dynamic items
    final List<dynamic> data = response.data as List<dynamic>;
    // Map each item in the list to a NotificationModel
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  // New method to mark a notification as read
  Future<void> markAsRead(String notificationId,String token) async {
    // We don't need the response body, but we await to ensure it completes.
    await _api.dio.put("/notifications/$notificationId/read",options: Options(headers: {"Authorization": "Bearer $token"}));
  }
}