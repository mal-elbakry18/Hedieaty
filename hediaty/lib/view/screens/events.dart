/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();

  String _sortOption = 'Date'; // Default sorting by date
  late Stream<List<Map<String, dynamic>>> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = _eventController.fetchEvents(); // Initialize events stream
  }

  // Handle Sort Change
  void _changeSortOption(String newOption) {
    setState(() {
      _sortOption = newOption;
    });
  }

  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    if (_sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    } else if (_sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent'); // Navigate to create event
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort Options Dropdown
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                ),
                DropdownButton<String>(
                  value: _sortOption,
                  items: ['Date', 'Category']
                      .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _changeSortOption(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _eventsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final events = _sortEvents(snapshot.data!); // Sort events dynamically

                if (events.isEmpty) {
                  return Center(child: Text('No events found.'));
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          event['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category: ${event['category']}'),
                            Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(event['date']))}'),
                          ],
                        ),
                        trailing: Icon(Icons.event, color: Colors.orange[800]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2), // Highlight Events tab
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
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();

  String _sortOption = 'Date'; // Default sorting by date
  late Stream<List<Map<String, dynamic>>> _eventsStream;

  @override
  void initState() {
    super.initState();
    _eventsStream = _eventController.fetchEvents(); // Initialize events stream
  }

  // Handle Sort Change
  void _changeSortOption(String newOption) {
    setState(() {
      _sortOption = newOption;
    });
  }

  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    if (_sortOption == 'Date') {
      events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    } else if (_sortOption == 'Category') {
      events.sort((a, b) => a['category'].compareTo(b['category']));
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        titleTextStyle:TextStyle(
          color: Color(0xFFFFF3E0),
          fontSize: 23,
          fontWeight: FontWeight.bold,)  ,
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent'); // Navigate to create event
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort Options Dropdown
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sort By:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                ),
                DropdownButton<String>(
                  value: _sortOption,
                  items: ['Date', 'Category']
                      .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _changeSortOption(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _eventsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final events = _sortEvents(snapshot.data!); // Sort events dynamically

                if (events.isEmpty) {
                  return Center(child: Text('No events found.'));
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      color: Color(0xFFFFF3E0), // Creamy orange color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Name
                            Text(
                              event['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange, // White text
                              ),
                            ),
                            SizedBox(height: 8),
                            // Event Date
                            Text(
                              'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange, // White text
                              ),
                            ),
                            SizedBox(height: 4),
                            // Event Creator
                            Text(
                              'Created by: ${event['creatorName']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange, // Light white text
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2), // Highlight Events tab
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

    // Initialize streams for events
    _myEventsStream = _eventController.fetchMyEvents();
    _friendsEventsStream = _eventController.fetchFriendsEvents();
  }

  // Delete an event
  Future<void> _deleteEvent(String eventId) async {
    try {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: ${e.toString()}')),
      );
    }
  }

  // Render a list of events
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> eventStream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: eventStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!;

        if (events.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[600],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              color: Color(0xFFFFF3E0), // Creamy orange background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Name
                    Text(
                      event['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Event Date
                    Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 4),

                    // Event Category
                    Text(
                      'Category: ${event['category']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[600],
                      ),
                    ),
                    SizedBox(height: 4),

                    // Event Creator
                    Text(
                      'Created by: ${event['creatorName']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[600],
                      ),
                    ),
                    SizedBox(height: 10),

                    // Edit & Delete Buttons (only for "My Events")
                    if (isMyEvents)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/editEvent',
                                arguments: event,
                              ); // Pass the event to the edit screen
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.orange[800]),
                            ),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () => _deleteEvent(event['id']), // Pass the event ID
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.orange[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Events Tab
          _buildEventList(_myEventsStream, true),

          // Friends' Events Tab
          _buildEventList(_friendsEventsStream, false),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2), // Highlight Events tab
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
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

    // Initialize streams for "My Events" and "Friends' Events"
    _myEventsStream = _eventController.fetchMyEvents();
    _friendsEventsStream = _eventController.fetchFriendsEvents();
  }

  // Delete an event
  Future<void> _deleteEvent(String eventId) async {
    try {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: ${e.toString()}')),
      );
    }
  }

  // Build a list of events
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> eventStream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: eventStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!;

        if (events.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[600],
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              color: Color(0xFFFFF3E0), // Creamy orange background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Name
                    Text(
                      event['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Event Date
                    Text(
                      'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                      ),
                    ),
                    SizedBox(height: 4),

                    // Event Category
                    Text(
                      'Category: ${event['category']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[600],
                      ),
                    ),
                    SizedBox(height: 4),

                    // Event Creator
                    Text(
                      'Created by: ${event['creatorName']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[600],
                      ),
                    ),
                    SizedBox(height: 10),

                    // Edit & Delete Buttons (only for "My Events")
                    if (isMyEvents)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/editEvent',
                                arguments: event,
                              ); // Navigate to edit screen
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.orange[800]),
                            ),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () => _deleteEvent(event['id']), // Delete event
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.orange[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Events Tab
          _buildEventList(_myEventsStream, true),

          // Friends' Events Tab
          _buildEventList(_friendsEventsStream, false),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2), // Highlight Events tab
    );
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  final EventController _eventController = EventController();

  late TabController _tabController;
  late Future<List<Map<String, dynamic>>> _myEventsFuture;
  late Future<List<Map<String, dynamic>>> _friendsEventsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize event data using Future
    _myEventsFuture = _eventController.fetchMyEventsFuture();
    _friendsEventsFuture = _eventController.fetchFriendsEventsFuture();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController to avoid memory leaks
    super.dispose();
  }

  // Delete Event
  Future<void> _deleteEvent(String eventId) async {
    try {
      await _eventController.deleteEvent(eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully!')),
      );
      // Refresh the events
      setState(() {
        _myEventsFuture = _eventController.fetchMyEventsFuture();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: ${e.toString()}')),
      );
    }
  }

  // Build Event List View
  Widget _buildEventList(Future<List<Map<String, dynamic>>> eventFuture, bool isMyEvents) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: eventFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events found.' : 'No friends\' events found.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[600],
              ),
            ),
          );
        } else {
          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                color: Color(0xFFFFF3E0), // Creamy orange background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Name
                      Text(
                        event['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      SizedBox(height: 8),

                      // Event Date
                      Text(
                        'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[700],
                        ),
                      ),
                      SizedBox(height: 4),

                      // Event Category
                      Text(
                        'Category: ${event['category']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[600],
                        ),
                      ),
                      SizedBox(height: 4),

                      // Event Creator
                      Text(
                        'Created by: ${event['creatorName']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[600],
                        ),
                      ),
                      SizedBox(height: 10),

                      // Edit & Delete Buttons (only for "My Events")
                      if (isMyEvents)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/editEvent',
                                  arguments: event,
                                ); // Pass the event to the edit screen
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.orange[800]),
                              ),
                            ),
                            SizedBox(width: 10),
                            TextButton(
                              onPressed: () => _deleteEvent(event['id']), // Pass the event ID
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
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
        title: Text('Events'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.orange[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Events Tab
          _buildEventList(_myEventsFuture, true),

          // Friends' Events Tab
          _buildEventList(_friendsEventsFuture, false),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2), // Highlight Events tab
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

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();

  // Confirmation Dialog for Delete
  Future<void> _confirmDelete(String eventId) async {
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
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _eventController.deleteEvent(eventId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _eventController.fetchMyEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(child: Text('No events created.'));
          }

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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(event['id']),
                    ),
                  ),
                ),
              );
            },
          );
        },
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

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();

  // Confirm Delete Dialog
  Future<void> _confirmDelete(String eventId) async {
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
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _eventController.deleteEvent(eventId);
      setState(() {}); // Refresh the list dynamically
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/createEvent');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _eventController.fetchMyEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(child: Text('No events created.'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/eventDetails',
                    arguments: event['id'], // Pass event ID
                  );
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(event['id']),
                    ),
                  ),
                ),
              );
            },
          );
        },
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

class _EventsPageState extends State<EventsPage> {
  final EventController _eventController = EventController();

  String _filterOption = 'My Events'; // Default to My Events
  String _sortOption = 'Date'; // Default to sorting by Date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortOption = value;
              });
            },
            itemBuilder: (context) {
              return ['Date', 'Name', 'Category']
                  .map((option) => PopupMenuItem(value: option, child: Text(option)))
                  .toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle between My Events and Friends' Events
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('My Events'),
                selected: _filterOption == 'My Events',
                onSelected: (isSelected) {
                  setState(() {
                    _filterOption = 'My Events';
                  });
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text('Friends\' Events'),
                selected: _filterOption == 'Friends\' Events',
                onSelected: (isSelected) {
                  setState(() {
                    _filterOption = 'Friends\' Events';
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _filterOption == 'My Events'
                  ? _eventController.fetchMyEvents()
                  : _eventController.fetchFriendsEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found.'));
                }

                // Apply sorting
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
                          title: Text(event['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(event['date']))}\n'
                                'Category: ${event['category']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(event['id']),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  // Confirmation Dialog for Delete
  Future<void> _confirmDelete(String eventId) async {
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
            onPressed: () => Navigator.pop(context, true),
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
      setState(() {});
    }
  }

  // Sort Events
  List<Map<String, dynamic>> _sortEvents(List<Map<String, dynamic>> events) {
    switch (_sortOption) {
      case 'Name':
        events.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Category':
        events.sort((a, b) => a['category'].compareTo(b['category']));
        break;
      default: // Sort by Date
        events.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    }
    return events;
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

  // Confirmation Dialog for Deleting an Event
  Future<void> _confirmDelete(String eventId) async {
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
            onPressed: () => Navigator.pop(context, true),
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
    }
  }

  // Build the Event List
  Widget _buildEventList(Stream<List<Map<String, dynamic>>> eventStream, bool isMyEvents) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: eventStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return Center(
            child: Text(
              isMyEvents ? 'No events created yet.' : 'No friends\' events available.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            final isOwner = event['userId'] == _eventController.currentUserId; // Check ownership

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
                  trailing: isOwner
                      ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(event['id']),
                  )
                      : null, // Hide delete button if not the owner
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.orange[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'My Events'),
            Tab(text: 'Friends\' Events'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Events Tab
          _buildEventList(_eventController.fetchMyEvents(), true),

          // Friends' Events Tab
          _buildEventList(_eventController.fetchFriendsEvents(), false),
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
                      ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await _confirmDelete(event['id']);
                      if (shouldDelete) setState(() {});
                    },
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
          _buildEventList(_eventController.fetchMyEvents(), true),
          _buildEventList(_eventController.fetchFriendsEvents(), false),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
