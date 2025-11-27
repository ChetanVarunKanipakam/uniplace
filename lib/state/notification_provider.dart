// lib/state/notification_provider.dart

import 'package:flutter/material.dart';
import '../data/models/notification_model.dart';
import '../data/repositories/notification_repository.dart';
import '../state/auth_provider.dart';
import 'package:provider/provider.dart';
class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repo = NotificationRepository();

  List<NotificationModel> _notifications = [];
  bool _loading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadNotifications(BuildContext context) async {
    _loading = true;
    _error = null;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    notifyListeners();
    try {
      _notifications = await _repo.getNotifications(token);
    } catch (e) {
      _error = "Failed to load notifications.";
      _notifications = [];
    }
    _loading = false;
    notifyListeners();
  }

  // New method for optimistic UI update
  Future<void> markAsRead(String notificationId,BuildContext context) async {
    // Find the index of the notification to updat
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token == null) {
      throw Exception("User not authenticated");
    }
    final int index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].read) {
      // Optimistically update the local state
      _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          read: true, // Set to read
          createdAt: _notifications[index].createdAt);
      notifyListeners();

      try {
        // Make the API call in the background
        await _repo.markNotificationAsRead(notificationId,token);
      } catch (e) {
        // If the API call fails, revert the change
        _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            title: _notifications[index].title,
            message: _notifications[index].message,
            type: _notifications[index].type,
            read: false, // Revert to unread
            createdAt: _notifications[index].createdAt);
        notifyListeners();
        // Optionally, show an error message to the user
      }
    }
  }
}