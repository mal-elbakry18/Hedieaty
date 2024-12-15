import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _navigateToPage(BuildContext context, int index) {
    final routes = [
      '/home',         // 0: Home Page
      '/friends',      // 1: Friends Page
      '/events',       // 2: Events/Calendar Page
      '/notifications', // 3: Notifications Page
      '/profile',      // 4: Profile Page
    ];

    if (index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateToPage(context, index),
      selectedItemColor: Colors.white, // Highlighted item color
      unselectedItemColor: Colors.orange[200], // Dimmed item color
      backgroundColor: Colors.orange[800], // Same color as AppBar
      type: BottomNavigationBarType.fixed, // Ensure items are fixed
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
