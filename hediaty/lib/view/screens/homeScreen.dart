/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome message
            Text(
              'Welcome, ${user?.displayName ?? 'User'}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Email display
            Text(
              'Email: ${user?.email ?? 'N/A'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            // Future navigation button placeholder
            ElevatedButton(
              onPressed: () {
                // Navigate to another screen or functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Future feature coming soon!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                minimumSize: Size(200, 50),
              ),
              child: Text('Explore Features'),
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
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomepageController _homepageController = HomepageController();

  late Future<List<Map<String, dynamic>>> _upcomingEvents;
  late Future<List<Map<String, dynamic>>> _friendsList;
  late Future<int> _notificationCount;

  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      _upcomingEvents = _homepageController.fetchUpcomingEvents(userId);
      _friendsList = _homepageController.fetchFriendsList(userId);
      _notificationCount = _homepageController.fetchNotificationCount(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // TODO: Handle menu functionality
          },
        ),
        actions: [
          FutureBuilder<int>(
            future: _notificationCount,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return NotificationIcon(
                icon: Icons.notifications,
                notificationCount: count,
                onPressed: () {
                  // TODO: Navigate to Notifications Page
                  Navigator.pushNamed(context, '/notifications');
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slide Section (Under App Bar)
            Text(
              'Welcome to Hedieaty!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Create Event/List Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createEvent');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Create Event/List',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // Add Friend Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addFriend');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Add Friend',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Upcoming Events Widget
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/allEvents');
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _upcomingEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No upcoming events.'));
                } else {
                  final events = snapshot.data!;
                  return Column(
                    children: events.map((event) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(event['name']),
                          subtitle: Text(event['date']),
                          trailing: Icon(Icons.event, color: Colors.orange[800]),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 30),

            // Friends List Widget
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/allFriends');
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _friendsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No friends added.'));
                } else {
                  final friends = snapshot.data!;
                  return Column(
                    children: friends.map((friend) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(friend['name']),
                          trailing: Icon(Icons.person, color: Colors.orange[800]),
                        ),
                      );
                    }).toList(),
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

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAllPressed;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.onViewAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: Text(
            'View All',
            style: TextStyle(color: Colors.orange[800]),
          ),

        ),

      ],
    );
  }
}
*/


//last working code before decoration
/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomepageController _homepageController = HomepageController();

  late Future<List<Map<String, dynamic>>> _upcomingEvents;
  late Future<List<Map<String, dynamic>>> _friendsList;
  late Future<int> _notificationCount;

  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      _upcomingEvents = _homepageController.fetchUpcomingEvents(userId);
      _friendsList = _homepageController.fetchFriendsList(userId);
      _notificationCount = _homepageController.fetchNotificationCount(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange[800],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          FutureBuilder<int>(
            future: _notificationCount,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return NotificationIcon(
                icon: Icons.notifications,
                notificationCount: count,
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(), // Slide menu added here
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slide Section (Under App Bar)
            /*Text(
              'Welcome to Hedieaty!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),*/
            SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Create Event/List Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createEvent');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Create Event/List',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // Add Friend Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addFriend');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Add Friend',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Upcoming Events Widget
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/allEvents');
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _upcomingEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No upcoming events.'));
                } else {
                  final events = snapshot.data!;
                  return Column(
                    children: events.map((event) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(event['name']),
                          subtitle: Text(event['date']),
                          trailing: Icon(Icons.event, color: Colors.orange[800]),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 30),

            // Friends List Widget
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/allFriends');
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _friendsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No friends added.'));
                } else {
                  final friends = snapshot.data!;
                  return Column(
                    children: friends.map((friend) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(friend['name']),
                          trailing: Icon(Icons.person, color: Colors.orange[800]),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Highlight Home tab
      ),
    );
  }
}
*/

//Last Working Code
/*


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomepageController _homepageController = HomepageController();

  late Future<List<Map<String, dynamic>>> _upcomingEvents;
  late Future<List<Map<String, dynamic>>> _friendsList;
  late Future<int> _notificationCount;

  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      _upcomingEvents = _homepageController.fetchUpcomingEvents(userId);
      _friendsList = _homepageController.fetchFriendsList(userId);
      _notificationCount = _homepageController.fetchNotificationCount(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), // Standard AppBar height
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16), // Rounded bottom corners
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            title: const Text('Home'),
            backgroundColor: Colors.orange[800],
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              FutureBuilder<int>(
                future: _notificationCount,
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return NotificationIcon(
                    icon: Icons.notifications,
                    notificationCount: count,
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: CustomDrawer(), // Slide menu added here
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Text(
              'Welcome to Hedieaty!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),*/
            const SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Create Event/List Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createEvent');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Create Event/List',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Add Friend Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addFriend');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Add Friend',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Upcoming Events Widget
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/events');
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _upcomingEvents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No upcoming events.'));
                } else {
                  final events = snapshot.data!;
                  return Column(
                    children: events.map((event) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(event['name']),
                          subtitle: Text(event['date']),
                          trailing: Icon(Icons.event, color: Colors.orange[800]),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 30),

            // Friends List Widget
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/allFriends');
              },
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _friendsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('No friends added.'));
                } else {
                  final friends = snapshot.data!;
                  return Column(
                    children: friends.map((friend) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          title: Text(friend['name']),
                          trailing: Icon(Icons.person, color: Colors.orange[800]),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0, // Highlight Home tab
      ),
    );
  }
}

*/

//Not working

/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_drawer.dart';
import '../../controllers/friend_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final HomepageController _homepageController = HomepageController();
  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Future<int> _notificationCount;
  final FriendController _friendController = FriendController();



  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _friendsStream = _friendController.fetchFriends();
    } else {
      // If user is null, use an empty stream
      _friendsStream = Stream.value([]);
    }


    if (userId != null) {
      // Initialize the stream for friends
      _friendsStream = _homepageController.fetchFriendsStream(userId);
      // Initialize notifications count
      _notificationCount = _homepageController.fetchNotificationCount(userId);
    } else {
      _friendsStream = const Stream.empty(); // Default empty stream for safety
      _notificationCount = Future.value(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), // Standard AppBar height
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16), // Rounded bottom corners
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            title: const Text('Home'),
            backgroundColor: Colors.orange[800],
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              FutureBuilder<int>(
                future: _notificationCount,
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return NotificationIcon(
                    icon: Icons.notifications,
                    notificationCount: count,
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(), // Slide menu added here
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Friends List Header
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/friends');
              },
            ),
            SizedBox(
              height: 200, // Fixed height for friend list
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No friends added.'));
                  } else {
                    final friends = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.orange[100],
                                  child: const Icon(Icons.person, size: 40, color: Colors.orange),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${friend['first_name']} ${friend['last_name']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 30),

            // Add more widgets below...
            const Text(
              "Upcoming Events",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add future events or any other logic here...
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 0, // Highlight Home tab
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '/controllers/friend_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomepageController _homepageController = HomepageController();
  final FriendController _friendController = FriendController();

  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Future<int> _notificationCount;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Friends list stream
      _friendsStream = _friendController.fetchFriends();

      // Notification count future
      _notificationCount = _homepageController.fetchNotificationCount(user.uid);
    } else {
      // Default empty states
      _friendsStream = Stream.value([]);
      _notificationCount = Future.value(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56), // Standard AppBar height
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16), // Rounded bottom corners
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            title: const Text('Home'),
            backgroundColor: Colors.orange[800],
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              // Notification Icon
              FutureBuilder<int>(
                future: _notificationCount,
                builder: (context, snapshot) {
                  final count = snapshot.data ?? 0;
                  return NotificationIcon(
                    icon: Icons.notifications,
                    notificationCount: count,
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      drawer: const CustomDrawer(),

      // Body Content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Friends List Header
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/friends');
              },
            ),

            // Friends List StreamBuilder
            SizedBox(
              height: 200, // Fixed height for horizontal friend list
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No friends added yet.'),
                    );
                  } else {
                    final friends = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.orange[100],
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${friend['first_name']} ${friend['last_name']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 30),

            // Upcoming Events Header
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/events');
              },
            ),

            // Placeholder for Events
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Upcoming Events will be displayed here!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
*/

//Working but missing
/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '/controllers/friend_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomepageController _homepageController = HomepageController();
  final FriendController _friendController = FriendController();

  // Default empty streams for initialization
  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Future<int> _notificationCount;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _friendsStream = _friendController.fetchFriends();
      _notificationCount = _homepageController.fetchNotificationCount(user.uid);
    } else {
      // Provide fallback defaults for safety
      _friendsStream = Stream.value([]);
      _notificationCount = Future.value(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.orange[800],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          FutureBuilder<int>(
            future: _notificationCount,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return NotificationIcon(
                icon: Icons.notifications,
                notificationCount: count,
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Friends List Header
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/friends');
              },
            ),

            // Friends List StreamBuilder
            SizedBox(
              height: 200,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No friends added.'));
                  } else {
                    final friends = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return _buildFriendCard(friend);
                      },
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 30),

            // Upcoming Events Header
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/events');
              },
            ),

            // Placeholder for Events
            SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Upcoming Events will be displayed here!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // Helper method to build friend cards
  Widget _buildFriendCard(Map<String, dynamic> friend) {
    return Card(
      margin: const EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange[100],
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${friend['first_name']} ${friend['last_name']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
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
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/homepage_controller.dart';
import '/controllers/friend_controller.dart';
import '/controllers/events_controller.dart';
import '../widgets/notification_icon.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_header.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomepageController _homepageController = HomepageController();
  final FriendController _friendController = FriendController();
  final EventController _eventController = EventController();

  // Streams and Futures
  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Stream<List<Map<String, dynamic>>> _eventsStream;
  late Future<int> _notificationCount;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _friendsStream = _friendController.fetchFriends();
      _eventsStream = _eventController.fetchMyEvents();
      _notificationCount = _homepageController.fetchNotificationCount(user.uid);
    } else {
      _friendsStream = Stream.value([]);
      _eventsStream = Stream.value([]);
      _notificationCount = Future.value(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.orange[800],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          FutureBuilder<int>(
            future: _notificationCount,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return NotificationIcon(
                icon: Icons.notifications,
                notificationCount: count,
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
           // const SizedBox(height: 20),
            /*Text(
              'Welcome to Hediaty!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),*/
            const SizedBox(height: 20),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createEvent');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Create Event/List',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addFriend');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Add Friend',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Friends List Section
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/friends');
              },
            ),
            SizedBox(
              height: 200,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No friends added.'));
                  } else {
                    final friends = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return _buildFriendCard(friend);
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 30),

            // Events Section
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () {
                Navigator.pushNamed(context, '/events');
              },
            ),
            SizedBox(
              height: 200,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _eventsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No upcoming events.'));
                  } else {
                    final events = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _buildEventCard(event);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // Friend Card Widget
  Widget _buildFriendCard(Map<String, dynamic> friend) {
    return Card(
      margin: const EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange[100],
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${friend['first_name']} ${friend['last_name']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Event Card Widget
  Widget _buildEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event,
              size: 40,
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            Text(
              event['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              event['date'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
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
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/friend_controller.dart';
import '/controllers/events_controller.dart';
import '../widgets/section_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FriendController _friendController = FriendController();
  final EventController _eventController = EventController();

  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Stream<List<Map<String, dynamic>>> _myEventsStream;
  late Stream<List<Map<String, dynamic>>> _friendsEventsStream;

  @override
  void initState() {
    super.initState();
    _friendsStream = _friendController.fetchFriends();
    _myEventsStream = _eventController.fetchMyEvents();
    _friendsEventsStream = _eventController.fetchFriendsEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.orange[800],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/createEvent'),
                  child: const Text('Create Event'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/addFriend'),
                  child: const Text('Add Friend'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // My Events
            SectionHeader(
              title: 'My Events',
              onViewAllPressed: () => Navigator.pushNamed(context, '/events'),
            ),
            _buildEventList(_myEventsStream, 'No events created yet.'),

            // Friends' Events
            SectionHeader(
              title: 'Friends\' Events',
              onViewAllPressed: () => Navigator.pushNamed(context, '/events'),
            ),
            _buildEventList(_friendsEventsStream, 'No friends\' events available.'),

            // Friends List
            SectionHeader(
              title: 'Friends List',
              onViewAllPressed: () => Navigator.pushNamed(context, '/friends'),
            ),
            _buildFriendsList(_friendsStream, 'No friends added.'),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildEventList(Stream<List<Map<String, dynamic>>> stream, String emptyMessage) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(emptyMessage);
        }
        final events = snapshot.data!;
        return Column(
          children: events.take(3).map((event) => ListTile(title: Text(event['name']))).toList(),
        );
      },
    );
  }

  Widget _buildFriendsList(Stream<List<Map<String, dynamic>>> stream, String emptyMessage) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(emptyMessage);
        }
        final friends = snapshot.data!;
        return Column(
          children: friends
              .take(3)
              .map((friend) => ListTile(title: Text('${friend['first_name']} ${friend['last_name']}')))
              .toList(),
        );
      },
    );
  }
}
*/

//Working but ui problem

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/controllers/friend_controller.dart';
import '/controllers/events_controller.dart';
import '../widgets/section_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FriendController _friendController = FriendController();
  final EventController _eventController = EventController();

  late Stream<List<Map<String, dynamic>>> _friendsStream;
  late Stream<List<Map<String, dynamic>>> _combinedEventsStream;

  @override
  void initState() {
    super.initState();
    _friendsStream = _friendController.fetchFriends();

    // Combine My Events and Friends' Events into one stream
    _combinedEventsStream = _combineEventStreams();
  }

  // Combine My Events and Friends' Events into one stream
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
        title: const Text('Home'),
        backgroundColor: Colors.orange[800],
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
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

            // Upcoming Events Section
            SectionHeader(
              title: 'Upcoming Events',
              onViewAllPressed: () => Navigator.pushNamed(context, '/events'),
            ),
            SizedBox(
              height: 200,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _combinedEventsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No upcoming events.'));
                  } else {
                    final events = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 160,
                            child: ListTile(
                              title: Text(event['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Date: ${event['date']}'),
                              onTap: () {
                                Navigator.pushNamed(context, '/eventDetails', arguments: event['id']);
                              },
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
              height: 150,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _friendsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No friends added.'));
                  } else {
                    final friends = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        final friend = friends[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.orange[100],
                                  child: const Icon(Icons.person, size: 35, color: Colors.orange),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${friend['first_name']} ${friend['last_name']}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

