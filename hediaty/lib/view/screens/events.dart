/*mport 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  late TabController _tabController;
  String _sortOption = 'Date'; // Default sorting option

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sort Events
  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    if (_sortOption == 'Name') {
      events.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    } else if (_sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    }
    return events;
  }

  // Build Event List
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> stream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        final events = _sortEvents(snapshot.data!);
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/eventDetails', arguments: event['id']);
              },
              child: Card(
                color: const Color(0xFFFFF3E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    event['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}\n'
                        'Created by: ${event['creatorName']}',
                  ),
                  trailing: isMyEvents
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(context, '/editEvent', arguments: event);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final shouldDelete = await _confirmDelete(event['id']);
                          if (shouldDelete) setState(() {});
                        },
                      ),
                    ],
                  )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Confirmation Dialog for Deleting an Event
  Future<bool> _confirmDelete(String eventId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            items: ['Date', 'Name', 'Category']
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _sortOption = value;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(_eventController.fetchMyEvents(), true), // Calls a new instance
          _buildEventList(_eventController.fetchFriendsEvents(), false), // Calls a new instance
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  late TabController _tabController;
  String _sortOption = 'Date';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    if (_sortOption == 'Name') {
      events.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    } else if (_sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    }
    return events;
  }

  Widget _buildEventList(Stream<List<Map<String, dynamic>>> stream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Stream error: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        final events = _sortEvents(snapshot.data!);
        print("Loaded ${events.length} events.");
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/eventDetails', arguments: event['id']);
              },
              child: Card(
                color: const Color(0xFFFFF3E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    event['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}\n'
                        'Created by: ${event['creatorName']}',
                  ),
                  trailing: isMyEvents
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(context, '/editEvent', arguments: event);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final shouldDelete = await _confirmDelete(event['id']);
                          if (shouldDelete) setState(() {});
                        },
                      ),
                    ],
                  )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmDelete(String eventId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            items: ['Date', 'Name', 'Category']
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _sortOption = value;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(_eventController.fetchMyEvents(), true),
          _buildEventList(_eventController.fetchFriendsEvents(), false),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
*/

//working code but taking too much time to load
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  late TabController _tabController;

  late Stream<List<Map<String, dynamic>>> _myEventsStream;
  late Stream<List<Map<String, dynamic>>> _friendsEventsStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Convert streams to broadcast streams
    _myEventsStream = _eventController.fetchMyEvents().asBroadcastStream();
    _friendsEventsStream = _eventController.fetchFriendsEvents().asBroadcastStream();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sort Events
  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events, String sortOption) {
    if (sortOption == 'Name') {
      events.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    } else if (sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    }
    return events;
  }

  // Build Event List
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> stream, String sortOption, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        final events = _sortEvents(snapshot.data!, sortOption);
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/eventDetails', arguments: event['id']);
              },
              child: Card(
                color: const Color(0xFFFFF3E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    event['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}\n'
                        'Created by: ${event['creatorName']}',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String sortOption = 'Date'; // Default sorting option
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        actions: [
          DropdownButton<String>(
            value: sortOption,
            items: ['Date', 'Name', 'Category']
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  sortOption = value;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(_myEventsStream, sortOption, true),
          _buildEventList(_friendsEventsStream, sortOption, false),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  late TabController _tabController;

  late final Stream<List<Map<String, dynamic>>> _myEventsStream;
  late final Stream<List<Map<String, dynamic>>> _friendsEventsStream;

  String _sortOption = 'Date'; // Default sorting option

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize streams once to avoid re-listening issues
    _myEventsStream = _eventController.fetchMyEvents();
    _friendsEventsStream = _eventController.fetchFriendsEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sort Events
  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    if (_sortOption == 'Name') {
      events.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    } else if (_sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    }
    return events;
  }

  // Build Event List
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> stream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        // Sort events before displaying them
        final events = _sortEvents(snapshot.data!);

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/eventDetails', arguments: event['id']);
              },
              child: Card(
                color: const Color(0xFFFFF3E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    event['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}\n'
                        'Category: ${event['category']}\n'
                        'Created by: ${event['creatorName']}',
                  ),
                  trailing: isMyEvents
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(context, '/editEvent', arguments: event);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final shouldDelete = await _confirmDelete(event['id']);
                          if (shouldDelete) setState(() {});
                        },
                      ),
                    ],
                  )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Confirmation Dialog for Deleting an Event
  Future<bool> _confirmDelete(String eventId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            items: ['Date', 'Name', 'Category']
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _sortOption = value;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(_myEventsStream, true),
          _buildEventList(_friendsEventsStream, false),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();
  late TabController _tabController;

  late final Stream<List<Map<String, dynamic>>> _myEventsStream;
  late final Stream<List<Map<String, dynamic>>> _friendsEventsStream;

  String _sortOption = 'Date'; // Default sorting option

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Convert streams to broadcast streams to avoid re-listening issues
    _myEventsStream = _eventController.fetchMyEvents().asBroadcastStream();
    _friendsEventsStream = _eventController.fetchFriendsEvents().asBroadcastStream();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sort Events
  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    if (_sortOption == 'Name') {
      events.sort((a, b) => a['name'].compareTo(b['name']));
    } else if (_sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    } else if (_sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    }
    return events;
  }


  // Build Event List
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> stream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }

        // Sort events before displaying them
        final events = _sortEvents(snapshot.data!);

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/eventDetails', arguments: event['id']);
              },
              child: Card(
                color: const Color(0xFFFFF3E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    event['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}\n'
                        'Category: ${event['category']}\n'
                        'Created by: ${event['creatorId']}',
                  ),
                  trailing: isMyEvents
                      ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(context, '/editEvent', arguments: event);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final shouldDelete = await _confirmDelete(event['id']);
                          if (shouldDelete) setState(() {});
                        },
                      ),
                    ],
                  )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Confirmation Dialog for Deleting an Event
  Future<bool> _confirmDelete(String eventId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            items: ['Date', 'Name', 'Category']
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  _sortOption = value;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventList(_myEventsStream, true),
          _buildEventList(_friendsEventsStream, false),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
