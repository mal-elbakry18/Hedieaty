import 'package:flutter/material.dart';
import '/controllers/friend_controller.dart';
import '/controllers/events_controller.dart';
import '../widgets/section_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_drawer.dart';
import '/../controllers/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final FriendController _friendController = FriendController();
  final EventController _eventController = EventController();
  final NotificationController _notificationController = NotificationController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Stream<List<Map<String, dynamic>>> _combinedEventsStream;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _friendsStream = _friendController.fetchFriendsWithDetails();
    _combinedEventsStream = _combineEventStreams();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> _combineEventStreams() async* {
    final myEventsStream = _eventController.fetchMyEvents();
    final friendsEventsStream = _eventController.fetchFriendsEvents();

    await for (final myEvents in myEventsStream) {
      final friendsEvents = await friendsEventsStream.first;
      yield [...myEvents, ...friendsEvents];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.home, color: Colors.white),
            const SizedBox(width: 10),
            const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.orange[800],
        elevation: 0,
        actions: [
          StreamBuilder<int>(
            stream: _notificationController.getUnreadNotificationCountStream(),
            builder: (context, snapshot) {
              final unreadCount = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open search functionality (to be implemented)
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action Buttons: Create Event and Add Friend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/createEvent'),
                    icon: const Icon(Icons.event),
                    label: const Text('Create Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/addFriend'),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Friend'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Upcoming Events Section
              SectionHeader(
                title: 'Upcoming Events',
                onViewAllPressed: () => Navigator.pushNamed(context, '/events'),
              ),
              SizedBox(
                height: 220,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _combinedEventsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No upcoming events.'));
                    } else {
                      final events = snapshot.data!
                          .where((event) =>
                      event['name'].toLowerCase().contains(_searchQuery) ||
                          (event['creatorName'] ?? 'Unknown')
                              .toLowerCase()
                              .contains(_searchQuery))
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Hero(
                            tag: event['id'],
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Date: ${event['date']}',
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Creator: ${event['creatorId'] ?? 'Unknown'}',
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/eventDetails',
                                            arguments: event['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange[800],
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 10),
                                      ),
                                      child: const Text('View Details'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Friends List Section
              SectionHeader(
                title: 'Friends List',
                onViewAllPressed: () => Navigator.pushNamed(context, '/friends'),
              ),
              SizedBox(
                height: 180,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _friendsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No friends added.'));
                    } else {
                      final friends = snapshot.data!
                          .where((friend) =>
                          ('${friend['username'] ?? ''} ${friend['phone'] ?? ''}')
                              .toLowerCase()
                              .contains(_searchQuery))
                          .toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.orange[100],
                                      child:
                                      const Icon(Icons.person, size: 35, color: Colors.orange),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      friend['username'] ?? 'Unknown',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Phone: ${friend['phone'] ?? 'N/A'}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
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
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
