import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  void _navigateToPage(BuildContext context, int index) {
    final routes = [
      '/home',         // 0: Home Page
      '/friends',      // 1: Friends Page
      '/events',       // 2: Events/Calendar Page
      '/notifications', // 3: Notifications Page
      '/profile',      // 4: Profile Page
    ];

    if (index < routes.length && ModalRoute.of(context)?.settings.name != routes[index]) {
      Navigator.pushNamed(context, routes[index]); // Push new route onto the stack
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange[800], // Background color of the bottom nav bar
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16), // Rounded top corners
          topRight: Radius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 8,         // Shadow blur radius
            offset: Offset(0, -2), // Shadow offset: above the navbar
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16), // Match the Container's border radius
          topRight: Radius.circular(16),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _navigateToPage(context, index),
          selectedItemColor: Colors.white, // Selected item color
          unselectedItemColor: Colors.orange[200], // Unselected item color
          backgroundColor: Colors.orange[800], // Background color matches the container
          type: BottomNavigationBarType.fixed, // Ensures all items are evenly spaced
          elevation: 0, // Remove default elevation
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
        ),
      ),
    );
  }
}
