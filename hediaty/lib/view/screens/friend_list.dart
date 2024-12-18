/*import 'package:flutter/material.dart';
import '/controllers/friend_controller.dart';

class FriendsListScreen extends StatefulWidget {
  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final FriendController _friendController = FriendController();
  String _sortOption = 'Recently Added';

  Stream<List<Map<String, dynamic>>> _getFriendsStream() {
    return _friendController.fetchFriends();
  }

  // Sort friends dynamically based on selected option
  List<Map<String, dynamic>> _sortFriends(List<Map<String, dynamic>> friends) {
    if (_sortOption == 'Recently Added') {
      return friends..sort((a, b) => b['addedAt'].compareTo(a['addedAt']));
    } else {
      return friends..sort((a, b) => a['friendName'].compareTo(b['friendName']));
    }
  }

  // Build Friend List
  Widget _buildFriendList(Stream<List<Map<String, dynamic>>> friendStream) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: friendStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final friends = _sortFriends(snapshot.data!);

        if (friends.isEmpty) {
          return Center(child: Text('No friends added.'));
        }

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return Card(
              color: Color(0xFFFFF3E0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange[800],
                  child: Text(
                    friend['friendName'][0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  friend['friendName'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                subtitle: Text(friend['friendPhone']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteFriend(friend['friendId']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Delete Friend with Confirmation
  Future<void> _deleteFriend(String friendId) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Friend'),
        content: Text('Are you sure you want to delete this friend?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _friendController.deleteFriend(friendId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/addFriend'),
          ),
        ],
      ),
      body: _buildFriendList(_getFriendsStream()),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';
import '../../controllers/friend_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final FriendController _friendController = FriendController();
  String _sortOption = 'Name';

  // Sort Friends List
  List<Map<String, dynamic>> _sortFriends(List<Map<String, dynamic>> friends) {
    if (_sortOption == 'Name') {
      friends.sort((a, b) {
        final nameA = "${a['first_name']} ${a['last_name']}".toLowerCase();
        final nameB = "${b['first_name']} ${b['last_name']}".toLowerCase();
        return nameA.compareTo(nameB);
      });
    } else if (_sortOption == 'Recently Added') {
      friends.sort((a, b) {
        final Timestamp addedAtA = a['addedAt'] as Timestamp;
        final Timestamp addedAtB = b['addedAt'] as Timestamp;
        return addedAtB.compareTo(addedAtA); // Sort descending
      });
    }
    return friends;
  }

  // Delete Friend Confirmation
  Future<void> _confirmDelete(String friendId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Friend'),
        content: const Text('Are you sure you want to delete this friend?'),
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
      await _friendController.deleteFriend(friendId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
        backgroundColor: Colors.orange[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            items: ['Name', 'Recently Added']
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
            icon: const Icon(Icons.person_add),
            onPressed: () => Navigator.pushNamed(context, '/addFriend'),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _friendController.fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No friends added.'));
          }

          final friends = _sortFriends(snapshot.data!);

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(friend['friendName'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Phone: ${friend['friendPhone']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(friend['friendId']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/
