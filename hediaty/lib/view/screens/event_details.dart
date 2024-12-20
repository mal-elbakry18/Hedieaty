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

//Last working code before the gifts
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '/controllers/gift_controller.dart';

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
*/


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '/controllers/gift_controller.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final EventController _eventController = EventController();
  final GiftController _giftController = GiftController();

  Map<String, dynamic>? _event;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    try {
      final event = await _eventController.fetchEventDetails(widget.eventId);
      setState(() {
        _event = event;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading event: $e')),
      );
    }
  }

  Future<void> _deleteEvent() async {
    await _eventController.deleteEvent(widget.eventId);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event deleted successfully!')),
    );
  }

  Future<void> _showGiftManagementModal() async {
    final giftsStream = _giftController.fetchAllGifts(); // Fetch all gifts
    final eventGiftsStream = _giftController.fetchEventGifts(widget.eventId); // Fetch event gifts

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Manage Gifts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: giftsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No gifts available.'));
                    } else {
                      final gifts = snapshot.data!;
                      return ListView.builder(
                        itemCount: gifts.length,
                        itemBuilder: (context, index) {
                          final gift = gifts[index];
                          return ListTile(
                            leading: gift['imageUrl'] != null
                                ? Image.network(gift['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.card_giftcard),
                            title: Text(gift['name']),
                            subtitle: Text(gift['category']),
                            trailing: IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () async {
                                try {
                                  await _giftController.addGiftToEvent(
                                    eventId: widget.eventId,
                                    gift: gift,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gift added to event!')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEventGiftsModal() async {
    final eventGiftsStream = _giftController.fetchEventGifts(widget.eventId);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Event Gifts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: eventGiftsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No gifts added to this event.'));
                    } else {
                      final gifts = snapshot.data!;
                      return ListView.builder(
                        itemCount: gifts.length,
                        itemBuilder: (context, index) {
                          final gift = gifts[index];
                          return ListTile(
                            leading: gift['imageUrl'] != null
                                ? Image.network(gift['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.card_giftcard),
                            title: Text(gift['name']),
                            subtitle: Text(gift['category']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await _giftController.removeGiftFromEvent(
                                    eventId: widget.eventId,
                                    giftId: gift['id'],
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gift removed from event.')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_event == null) {
      return const Center(child: Text('Event not found.'));
    }

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
              onPressed: _showGiftManagementModal,
              child: const Text('Add Gifts'),
            ),
            ElevatedButton(
              onPressed: _showEventGiftsModal,
              child: const Text('View Event Gifts'),
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
            IconButton(
              icon: const Icon(Icons.card_giftcard, color: Colors.orange),
              onPressed: () async {
                try {
                  await _giftController.pledgeGift(eventId: widget.eventId, giftId: gift['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gift pledged successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
