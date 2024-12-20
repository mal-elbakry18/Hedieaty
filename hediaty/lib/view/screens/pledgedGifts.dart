import 'package:flutter/material.dart';
import '/controllers/gift_controller.dart';

class PledgedGiftsScreen extends StatefulWidget {
  const PledgedGiftsScreen({super.key});

  @override
  _PledgedGiftsScreenState createState() => _PledgedGiftsScreenState();
}

class _PledgedGiftsScreenState extends State<PledgedGiftsScreen> {
  final GiftController _giftController = GiftController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pledged Gifts'),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _giftController.fetchPledgedGiftsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No pledged gifts found.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            final pledgedGifts = snapshot.data!;
            return ListView.builder(
              itemCount: pledgedGifts.length,
              itemBuilder: (context, index) {
                final gift = pledgedGifts[index];
                final giftDetails = gift['giftDetails'] ?? {};

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: giftDetails['imageUrl'] != null && giftDetails['imageUrl'].isNotEmpty
                        ? Image.network(
                      giftDetails['imageUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                      },
                    )
                        : const Icon(Icons.card_giftcard, size: 50, color: Colors.grey),
                    title: Text(
                      giftDetails['name'] ?? 'Unknown Gift',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event: ${gift['eventName'] ?? 'Unknown Event'}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          'Pledged by: ${gift['pledgedByUsername'] ?? 'Unknown User'}',
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
