// lib/data/repositories/notification_repository.dart

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService _service = NotificationService();

  Future<List<NotificationModel>> getNotifications(String token) async {
    return await _service.fetchNotifications(token);
  }

  Future<void> markNotificationAsRead(String notificationId,String token) async {
    return await _service.markAsRead(notificationId,token);
  }
}