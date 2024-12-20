import 'package:flutter/material.dart';
import '../../controllers/gift_controller.dart';

class GiftScreen extends StatefulWidget {
  final String? statusFilter; // Optional filter for gifts

  const GiftScreen({Key? key, this.statusFilter}) : super(key: key);

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  final GiftController _giftController = GiftController();

  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
  }

  Future<void> _fetchCurrentUserId() async {
    try {
      final userId = await _giftController.getCurrentUserId();
      setState(() {
        _currentUserId = userId;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user ID: $e')),
      );
    }
  }

  Widget _buildGiftList() {
    if (_currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Use stream to fetch real-time gift updates
    final giftStream = _giftController.fetchMyGiftsStream();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: giftStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No gifts found.'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addGift');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                  ),
                  child: const Text('Add New Gift'),
                ),
              ],
            ),
          );
        }

        final gifts = snapshot.data!;
        return ListView.builder(
          itemCount: gifts.length,
          itemBuilder: (context, index) {
            final gift = gifts[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: gift['imageUrl'] != null && gift['imageUrl'].isNotEmpty
                    ? Image.network(
                  gift['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error, color: Colors.red),
                )
                    : const Icon(Icons.card_giftcard, size: 50),
                title: Text(gift['name']),
                subtitle: Text('Category: ${gift['category']}'),
                trailing: Text(
                  gift['status'] ?? 'Available',
                  style: TextStyle(
                    color: gift['status'] == 'pledged'
                        ? Colors.orange
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/giftDetails', arguments: gift);
                },
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
        title: const Text('My Gifts'),
        backgroundColor: Colors.orange[800],
      ),
      body: _buildGiftList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[800],
        onPressed: () {
          Navigator.pushNamed(context, '/addGift');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
