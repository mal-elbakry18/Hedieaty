import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          if (notifications.isEmpty) {
            return Center(child: Text('No notifications.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                child: ListTile(
                  title: Text(notification['title'] ?? 'No Title'),
                  subtitle: Text(notification['body'] ?? 'No Content'),
                  trailing: Icon(
                    notification['isRead'] ? Icons.done : Icons.notifications,
                    color: notification['isRead'] ? Colors.green : Colors.orange,
                  ),
                  onTap: () {
                    // Mark notification as read
                    FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(notification.id)
                        .update({'isRead': true});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
