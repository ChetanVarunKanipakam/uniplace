// lib/ui/pages/notification_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago; // Import timeago
import '../../data/models/notification_model.dart';
import '../../state/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).loadNotifications(context);
    });
  }

  // Helper to get an icon based on notification type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'new_job':
        return Icons.work_outline;
      case 'shortlist':
        return Icons.star_border;
      case 'new_schedule':
      case 'schedule_reminder':
        return Icons.calendar_today_outlined;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : provider.notifications.isEmpty
              ? const Center(
                  child: Text("You're all caught up!"),
                )
              : RefreshIndicator(
                  onRefresh:() {return provider.loadNotifications(context);},
                  child: ListView.builder(
                    itemCount: provider.notifications.length,
                    itemBuilder: (_, i) {
                      final NotificationModel n = provider.notifications[i];
                      final bool isRead = n.read;
                      final Color? cardColor = isRead
                          ? theme.cardColor
                          : theme.primaryColor.withOpacity(0.05);
                      final Color titleColor = isRead
                          ? theme.textTheme.titleMedium!.color!.withOpacity(0.6)
                          : theme.textTheme.titleMedium!.color!;

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: cardColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isRead
                                ? Colors.grey.withOpacity(0.3)
                                : theme.primaryColor.withOpacity(0.1),
                            child: Icon(
                              _getIconForType(n.type),
                              color: isRead ? Colors.grey : theme.primaryColor,
                            ),
                          ),
                          title: Text(n.title, style: TextStyle(color: titleColor, fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.message, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(
                                timeago.format(n.createdAt), // Formatted timestamp
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          onTap: () {
                            if (!n.read) {
                              // Mark as read when tapped
                              provider.markAsRead(n.id,context);
                            }
                            // You can add navigation logic here if needed
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}