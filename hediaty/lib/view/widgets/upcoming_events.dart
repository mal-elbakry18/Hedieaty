import 'package:flutter/material.dart';
import 'event_details.dart';

class UpcomingEventsWidget extends StatelessWidget {
  const UpcomingEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data for upcoming events
    final events = [
      EventDetails(
        eventName: 'John’s Birthday',
        date: 'Dec 15, 2024',
        createdBy: 'Alice',
      ),
      EventDetails(
        eventName: 'Wedding Party',
        date: 'Dec 18, 2024',
        createdBy: 'Bob',
      ),
      EventDetails(
        eventName: 'Christmas Gathering',
        date: 'Dec 25, 2024',
        createdBy: 'Charlie',
      ),
    ];

    return Column(
      children: events.map((event) => EventDetailsWidget(event: event)).toList(),
    );
  }
}
