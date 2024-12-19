/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final EventController _eventController = EventController();
  Map<String, dynamic>? _event;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    final event = await _eventController.fetchEventDetails(widget.eventId);
    setState(() {
      _event = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!['name']),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${_event!['description']}'),
            const SizedBox(height: 10),
            Text('Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(_event!['date']))}'),
            const SizedBox(height: 10),
            Text('Category: ${_event!['category']}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add gifts logic
              },
              child: const Text('Add Gifts'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editEvent', arguments: _event);
              },
              child: const Text('Edit Event'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final EventController _eventController = EventController();
  Map<String, dynamic>? _event;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    final event = await _eventController.fetchEventDetails(widget.eventId);
    setState(() {
      _event = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!['name']),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${_event!['description']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(_event!['date']))}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text('Category: ${_event!['category']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editEvent', arguments: _event);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
              child: const Text('Edit Event'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              child: const Text('Back to Events'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final EventController _eventController = EventController();
  Map<String, dynamic>? _event;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    final event = await _eventController.fetchEventDetails(widget.eventId);
    setState(() {
      _event = event;
    });
  }

  Future<void> _deleteEvent() async {
    await _eventController.deleteEvent(widget.eventId);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: Text(_event!['name']),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${_event!['description']}'),
            const SizedBox(height: 10),
            Text('Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(_event!['date']))}'),
            const SizedBox(height: 10),
            Text('Category: ${_event!['category']}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Add Gifts
              },
              child: const Text('Add Gifts'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editEvent', arguments: _event);
              },
              child: const Text('Edit Event'),
            ),
            ElevatedButton(
              onPressed: _deleteEvent,
              child: const Text('Delete Event', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
