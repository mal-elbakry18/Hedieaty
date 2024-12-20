import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController _controller = NotificationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.notifications_active_rounded, color: Colors.yellow, size: 24),
            const SizedBox(width: 8),
            const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications.'));
          }

          final notifications = snapshot.data!;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[100],
                    child: const Icon(Icons.notifications, color: Colors.orange),
                  ),
                  title: Text(notification['title'] ?? 'Notification',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notification['message'] ?? ''),
                  trailing: Text(
                    notification['timestamp'] != null
                        ? _formatTimestamp(notification['timestamp'])
                        : '',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'markAsRead') {
            await _controller.markAllAsRead();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All notifications marked as read!')),
            );
          } else if (value == 'clearNotifications') {
            final confirmed = await _showConfirmationDialog(context);
            if (confirmed) {
              await _controller.clearAllNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared!')),
              );
            }
          }
        },
        icon: const Icon(Icons.more_vert, color: Colors.orange),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'markAsRead',
            child: ListTile(
              leading: Icon(Icons.done_all, color: Colors.orange),
              title: Text('Mark All as Read'),
            ),
          ),
          const PopupMenuItem(
            value: 'clearNotifications',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Clear Notifications'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
        ],
      ),
    ) ??
        false;
  }
}
