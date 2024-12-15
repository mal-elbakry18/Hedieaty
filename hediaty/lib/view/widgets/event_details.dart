import 'package:flutter/material.dart';

class EventDetails {
  final String eventName;
  final String date;
  final String createdBy;

  EventDetails({
    required this.eventName,
    required this.date,
    required this.createdBy,
  });
}

class EventDetailsWidget extends StatelessWidget {
  final EventDetails event;

  const EventDetailsWidget({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.event, color: Colors.orange[800]),
        title: Text(
          event.eventName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              'Date: ${event.date}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Created by: ${event.createdBy}',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.orange[800]),
        onTap: () {
          // Navigate to Event Details Page (if required)
          Navigator.pushNamed(context, '/eventDetails', arguments: event);
        },
      ),
    );
  }
}
