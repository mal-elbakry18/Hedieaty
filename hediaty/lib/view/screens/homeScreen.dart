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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56), // Standard AppBar height
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16), // Rounded bottom corners
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
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
        ),
      ),
      drawer: CustomDrawer(), // Slide menu added here
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Highlight Home tab
      ),
    );
  }
}

