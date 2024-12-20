import 'package:flutter/material.dart';
import '/controllers/friend_controller.dart';

class FriendsListScreen extends StatelessWidget {
  final FriendController _friendController = FriendController();

  FriendsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _friendController.fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final friends = snapshot.data ?? [];
          if (friends.isEmpty) {
            return const Center(child: Text('No friends added yet.'));
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[100],
                    child: const Icon(Icons.person, color: Colors.orange),
                  ),
                  title: Text(
                    friend['friend_name'] ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Phone: ${friend['friend_phone'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(
                      context,
                      friend['friend_id'].toString(),
                      friend['friendship_id'].toString(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String friendId, String friendshipId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to remove this friend from your list?'),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  // Call the deleteFriend method from the controller
                  await _friendController.deleteFriend(friendId, friendshipId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend deleted successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting friend: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
