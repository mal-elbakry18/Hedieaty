import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/model/firebase/auth_services.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = "User"; // Default name if not fetched

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDetails = await AuthService().getUserDetails(user.uid);
      setState(() {
        userName = userDetails?['name'] ?? "User"; // Fallback to 'User'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange[800],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange[100],
                  child: Icon(Icons.person, size: 40, color: Colors.orange[800]),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome, $userName!', // Use fetched name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          ListTile(
            leading: Icon(Icons.home, color: Colors.orange[800]),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.orange[800]),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.orange[800]),
            title: Text('Events'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/events');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.grey),
            title: Text('About Us / Contact Us'),
            onTap: () {
              Navigator.pushNamed(context, '/aboutUs');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey),
            title: Text('Logout'),
            onTap: () async {
              await AuthService().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
