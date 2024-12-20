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
/*
import 'package:firebase_auth/firebase_auth.dart';
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
    final giftsStream = _giftController.fetchAllGifts();

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
            if (_event?['createdBy'] == FirebaseAuth.instance.currentUser?.uid) ...[
              ElevatedButton(
                onPressed: _deleteEvent,
                child: const Text('Delete Event', style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/editEvent', arguments: _event);
                },
                child: const Text('Edit Event'),
              ),
            ],

            ElevatedButton(
              onPressed: _showGiftManagementModal,
              child: const Text('Add Gifts'),
            ),
            ElevatedButton(
              onPressed: _showEventGiftsModal,
              child: const Text('View Event Gifts'),
            ),
          ],
        ),
      ),
    );
  }
}

*/
//working codee
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
  final GiftController _giftController = GiftController();

  Map<String, dynamic>? _event;
  List<String> _eventGiftIds = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEventDetails();
  }

  Future<void> _loadEventDetails() async {
    try {
      final event = await _eventController.fetchEventDetails(widget.eventId);
      final eventGifts = await _giftController.fetchEventGiftsOnce(widget.eventId);

      setState(() {
        _event = event;
        _eventGiftIds = eventGifts.map((gift) => gift['id'] as String).toList();
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

  Future<void> _addGiftToEvent(Map<String, dynamic> gift) async {
    if (_eventGiftIds.contains(gift['id'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift is already added to the event.')),
      );
      return;
    }

    try {
      await _giftController.addGiftToEvent(
        eventId: widget.eventId,
        gift: gift,
      );
      setState(() {
        _eventGiftIds.add(gift['id']);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift added to event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildEventGiftList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _giftController.fetchEventGifts(widget.eventId),
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
              final isPledged = gift['status'] == 'pledged';
              return ListTile(
                leading: gift['imageUrl'] != null
                    ? Image.network(
                  gift['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.card_giftcard),
                title: Text(gift['name']),
                subtitle: Text(
                    'Status: ${gift['status']}\nCategory: ${gift['category']}'),
                trailing: isPledged
                    ? ElevatedButton(
                  onPressed: () =>
                      _giftController.updateGiftStatus(gift['id'], 'available'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  child: const Text('Unpledge'),
                )
                    : ElevatedButton(
                  onPressed: () =>
                      _giftController.updateGiftStatus(gift['id'], 'pledged'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                  child: const Text('Pledge'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> _showGiftManagementModal() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search for gifts to add',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _giftController.fetchAllGifts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No gifts found.'));
                        } else {
                          final gifts = snapshot.data!
                              .where((gift) => gift['name']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                              .toList();
                          return ListView.builder(
                            itemCount: gifts.length,
                            itemBuilder: (context, index) {
                              final gift = gifts[index];
                              return ListTile(
                                leading: gift['imageUrl'] != null
                                    ? Image.network(
                                  gift['imageUrl'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                                    : const Icon(Icons.card_giftcard),
                                title: Text(gift['name']),
                                subtitle: Text(gift['category']),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.green),
                                  onPressed: () => _addGiftToEvent(gift),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addGift');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                    ),
                    child: const Text('Add New Gift'),
                  ),
                ],
              ),
            );
          },
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${_event!['description']}'),
                const SizedBox(height: 10),
                Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(_event!['date']))}'),
                const SizedBox(height: 10),
                Text('Category: ${_event!['category']}'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Gifts Added to Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildEventGiftList()),
          ElevatedButton(
            onPressed: _showGiftManagementModal,
            child: const Text('Manage Gifts'),
          ),
        ],
      ),
    );
  }
}
*/

/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/controllers/events_controller.dart';
import '/controllers/gift_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final GiftController _giftController = GiftController();
  final EventController _eventController = EventController();

  String _searchQuery = '';
  late Stream<List<Map<String, dynamic>>> _giftStream;
  late Stream<List<Map<String, dynamic>>> _searchableGiftStream;
  Map<String, dynamic>? _eventDetails;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
    _giftStream = _giftController.fetchEventGifts(widget.eventId);
    _searchableGiftStream = _giftController.fetchMyGiftsStream();
    _loadEventDetails();
  }

  Future<void> _fetchCurrentUserId() async {
    try {
      final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
      if (firebaseUserId == null) throw Exception("No logged-in user found.");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          _currentUserId = userDoc.data()?['user_id'];
        });
      } else {
        throw Exception("User document not found in Firestore.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user ID: $e')),
      );
    }
  }

  Future<void> _loadEventDetails() async {
    try {
      final details = await _eventController.fetchEventDetails(widget.eventId);
      setState(() {
        _eventDetails = details;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading event details: $e')),
      );
    }
  }

  Future<void> _addGiftToEvent(Map<String, dynamic> gift) async {
    final isAdded = await _giftController.isGiftAlreadyInEvent(widget.eventId, gift['id']);
    if (isAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift is already added to the event.')),
      );
      return;
    }

    try {
      await _giftController.addGiftToEvent(widget.eventId, gift);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift successfully added to the event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pledgeGift(String giftId) async {
    try {
      await _giftController.pledgeGift(widget.eventId, giftId, _currentUserId! as String);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift successfully pledged!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildEventDetails() {
    if (_eventDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _eventDetails!['name'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Description: ${_eventDetails!['description']}'),
          const SizedBox(height: 10),
          Text('Date: ${_eventDetails!['date']}'),
          const SizedBox(height: 10),
          Text('Category: ${_eventDetails!['category']}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEventGiftList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _giftStream,
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
              final isPledged = gift['status'] == 'pledged';
              return ListTile(
                leading: gift['imageUrl'] != null
                    ? Image.network(
                  gift['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.card_giftcard),
                title: Text(gift['name']),
                subtitle: Text(
                  isPledged
                      ? 'Pledged by: ${gift['pledgedBy']}'
                      : 'Status: Available',
                ),
                trailing: isPledged
                    ? const Icon(Icons.check, color: Colors.green)
                    : ElevatedButton(
                  onPressed: () => _pledgeGift(gift['id']),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Pledge'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _searchableGiftStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No gifts found.'));
        } else {
          final gifts = snapshot.data!
              .where((gift) => gift['name']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return ListTile(
                leading: gift['imageUrl'] != null
                    ? Image.network(
                  gift['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.card_giftcard),
                title: Text(gift['name']),
                subtitle: Text(gift['category']),
                trailing: ElevatedButton(
                  onPressed: () => _addGiftToEvent(gift),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Add'),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.orange[800],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _buildEventDetails(),
          ),
          Expanded(
            flex: 5,
            child: _buildEventGiftList(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Gifts',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}

*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  String _searchQuery = '';
  late Stream<List<Map<String, dynamic>>> _eventGiftStream;
  late Stream<List<Map<String, dynamic>>> _myGiftStream;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
    _fetchOwnershipStatus();
  }

  void _initializeStreams() {
    _eventGiftStream = _eventController.fetchEventGifts(widget.eventId);
    _myGiftStream = _giftController.fetchMyGiftsStream();
  }

  Future<void> _fetchOwnershipStatus() async {
    try {
      final currentUserId = await _eventController.getCurrentUserId();
      final eventDetails = await _eventController.fetchEventDetails(widget.eventId);

      if (eventDetails != null && currentUserId == eventDetails['creatorId']) {
        setState(() {
          isOwner = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching ownership status: $e')),
      );
    }
  }

  Future<void> _addGiftToEvent(Map<String, dynamic> gift) async {
    try {
      await _eventController.addGiftToEvent(widget.eventId, gift);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift successfully added to the event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _removeGiftFromEvent(String giftId) async {
    try {
      await _eventController.removeGiftFromEvent(widget.eventId, giftId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift removed from the event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  Future<void> _pledgeGift(String giftId, Map<String, dynamic> giftDetails) async {
    try {
      // Fetch the manually created user_id from Firestore
      final firebaseUserId = FirebaseAuth.instance.currentUser?.uid;
      if (firebaseUserId == null) throw Exception("No logged-in user found.");

      final userDoc = await _eventController.getUserDetailsByFirebaseUid(firebaseUserId);
      final currentUserId = userDoc['user_id'];
      final username = userDoc['username'];

      // Fetch the event name using the event ID
      final eventName = await _giftController.getEventNameById(widget.eventId);

      // Save pledged gift details to Firestore
      await _giftController.addPledgedGift(
        eventId: widget.eventId,
        giftId: giftId,
        pledgedBy: username, // Use the username for pledgedBy
        eventName: eventName, // Use the event name
        giftDetails: giftDetails, // Pass full gift details
      );

      // Update gift status in Firestore
      await _giftController.updateGiftStatus(giftId, widget.eventId, 'pledged');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift successfully pledged!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  Widget _buildGiftList(Stream<List<Map<String, dynamic>>> giftStream) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: giftStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No gifts found.'));
        } else {
          final gifts = snapshot.data!;
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return Card(
                child: ListTile(
                  leading: gift['imageUrl'] != null && gift['imageUrl'].isNotEmpty
                      ? Image.network(
                    gift['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  )
                      : const Icon(Icons.card_giftcard, size: 50, color: Colors.grey),
                  title: Text(gift['name']),
                  subtitle: Text(gift['category']),
                  trailing: isOwner
                      ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeGiftFromEvent(gift['id']),
                  )
                      : ElevatedButton(
                    onPressed: gift['status'] == 'pledged'
                        ? null
                        : () => _pledgeGift(gift['id'], gift),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      gift['status'] == 'pledged' ? Colors.grey : Colors.orange,
                    ),
                    child: Text(gift['status'] == 'pledged' ? 'Pledged' : 'Pledge'),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _myGiftStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No gifts available for adding.'));
        } else {
          final gifts = snapshot.data!
              .where((gift) => gift['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return ListTile(
                leading: gift['imageUrl'] != null && gift['imageUrl'].isNotEmpty
                    ? Image.network(
                  gift['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                )
                    : const Icon(Icons.card_giftcard, size: 50, color: Colors.grey),
                title: Text(gift['name']),
                subtitle: Text(gift['category']),
                trailing: ElevatedButton(
                  onPressed: () => _addGiftToEvent(gift),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Add'),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.orange[800],
      ),
      body: Column(
        children: [
          Expanded(flex: 3, child: _buildGiftList(_eventGiftStream)),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Gifts',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(flex: 4, child: _buildSearchResults()),
        ],
      ),
    );
  }
}
