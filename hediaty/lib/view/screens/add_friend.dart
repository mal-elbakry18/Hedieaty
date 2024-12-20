/*import 'package:flutter/material.dart';
import '/controllers/friend_controller.dart';

class AddFriendScreen extends StatefulWidget {
  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FriendController _friendController = FriendController();

  Future<void> _addFriend() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number.')),
      );
      return;
    }

    try {
      await _friendController.addFriendByPhone(phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend added successfully!')),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friend'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Friend\'s Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addFriend,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
              child: Text('Add Friend'),
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
import '/controllers/friend_controller.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FriendController _friendController = FriendController();

  Map<String, dynamic>? _friendData;
  bool _isLoading = false;

  // Search for Friend by Phone
  Future<void> _searchFriend() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final friend = await _friendController.fetchFriendByPhone(phoneNumber);
      if (friend == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found with this phone number.')),
        );
      } else {
        setState(() {
          _friendData = friend;
        });
        _showConfirmationCard();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show Sliding Confirmation Card
  void _showConfirmationCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.4,
          minChildSize: 0.2,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Confirm Friend",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange[100],
                  child: const Icon(Icons.person, size: 40, color: Colors.orange),
                ),
                const SizedBox(height: 10),
                Text(
                  "${_friendData?['first_name']} ${_friendData?['last_name']}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text("Phone: ${_friendData?['phoneNumber']}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close bottom sheet
                    await _addFriend();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  child: const Text('Add Friend'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Confirm and Add Friend
  Future<void> _addFriend() async {
    try {
      await _friendController.addFriendByPhone(_friendData!['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend added successfully!')),
      );
      setState(() {
        _friendData = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Friend's Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _searchFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              ),
              child: const Text('Search Friend'),
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
import '/controllers/friend_controller.dart';

class AddFriendScreen extends StatefulWidget {
  final String currentUserId;

  const AddFriendScreen({super.key, required this.currentUserId});

  @override
  _AddFriendScreenState createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FriendController _friendController = FriendController();
  Map<String, dynamic>? _friendData;

  void _searchFriend() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    final friend = await _friendController.searchFriendByPhone(phone);

    if (friend != null) {
      setState(() {
        _friendData = friend;
      });

      _showFriendConfirmation(friend);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user found with this phone number')),
      );
    }
  }

  void _showFriendConfirmation(Map<String, dynamic> friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            children: [
              Text(
                'Confirm Friend',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text('Username: ${friend['username']}'),
              Text('Phone: ${friend['number']}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _friendController.addFriendship(
                    widget.currentUserId,
                    friend['user_id'],
                  );
                  Navigator.pop(context); // Close bottom sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Friend added successfully!')),
                  );
                },
                child: const Text('Add Friend'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchFriend,
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

//new code
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/../controllers/friend_controller.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FriendController _friendController = FriendController();

  bool _isLoading = false;

  Future<void> _addFriend() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a phone number')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _friendController.addFriendByPhone(phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend added successfully!')),
      );
      Navigator.pop(context); // Go back after success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding friend: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Friend\'s Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _addFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
              ),
              child: const Text('Add Friend'),
            ),
          ],
        ),
      ),
    );
  }
}
