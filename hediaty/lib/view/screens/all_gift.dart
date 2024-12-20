//Working Code
/*import 'package:flutter/material.dart';
import '/../controllers/gift_controller.dart';

class GiftScreen extends StatelessWidget {
  final GiftController _giftController = GiftController();
  final String? statusFilter; // Optional status filter

  GiftScreen({super.key, this.statusFilter});

  void _updateGiftStatus(BuildContext context, String giftId, String newStatus) async {
    try {
      await _giftController.updateGiftStatus(giftId, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gift marked as $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gifts'),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: statusFilter == null
            ? _giftController.fetchAllGifts()
            : _giftController.fetchGiftsByStatus(statusFilter!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final gifts = snapshot.data ?? [];
          if (gifts.isEmpty) {
            return const Center(child: Text('No gifts available.'));
          }
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return ListTile(
                leading: Image.network(
                  gift['imageUrl'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(gift['name']),
                subtitle: Text("Category: ${gift['category']}"),
                trailing: Text("Status: ${gift['status']}"),
              );
            },
          );
        },
      ),
    );
  }
}
*/
//Last working code

/*import 'package:flutter/material.dart';
import '../../controllers/gift_controller.dart';

class GiftScreen extends StatefulWidget {
  final String? statusFilter; // Optional filter for gifts

  const GiftScreen({super.key, this.statusFilter});

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  final GiftController _giftController = GiftController();

  // Controllers for the Add Gift form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  String _selectedCategory = 'General';
  String _imageUrl = '';
  String _status = 'available'; // Default status
  final List<String> _categories = ['General', 'Electronics', 'Clothing', 'Books', 'Toys', 'Food'];

  // Function to show a dialog for adding a new gift
  Future<void> _showAddGiftDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Gift'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Gift Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: 'Where to Buy URL (optional)'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gift Status:'),
                    DropdownButton<String>(
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: 'available', child: Text('Available')),
                        DropdownMenuItem(value: 'pledged', child: Text('Pledged')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _status = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Add Image'),
                ),
                if (_imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.network(_imageUrl, height: 100),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addGift,
              child: const Text('Add Gift'),
            ),
          ],
        );
      },
    );
  }

  // Function to pick an image and upload it (simulate upload here)
  Future<void> _pickImage() async {
    // Simulate image selection
    setState(() {
      _imageUrl = 'https://via.placeholder.com/150'; // Replace with actual upload logic
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected successfully!')),
    );
  }

  Future<void> _addGift() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }

    try {
      await _giftController.addGift(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        imageUrl: _imageUrl.isNotEmpty ? _imageUrl : null,
        status: _status,
        purchaseUrl: _urlController.text.trim().isNotEmpty ? _urlController.text.trim() : null,
      );

      Navigator.pop(context); // Close the dialog
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding gift: $e')),
      );
    }
  }


  // Function to reset the form fields
  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _urlController.clear();
    setState(() {
      _selectedCategory = 'General';
      _imageUrl = '';
      _status = 'available';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.statusFilter == 'pledged' ? 'Pledged Gifts' : 'My Gifts',
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _giftController.fetchGifts(statusFilter: widget.statusFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No gifts found.'));
          } else {
            final gifts = snapshot.data!;
            return ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: gift['imageUrl'] != null
                        ? Image.network(gift['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.card_giftcard),
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
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[800],
        onPressed: _showAddGiftDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
*/


import 'package:flutter/material.dart';
import '../../controllers/gift_controller.dart';

class GiftScreen extends StatefulWidget {
  final String? statusFilter; // Optional filter for gifts

  const GiftScreen({super.key, this.statusFilter});

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  final GiftController _giftController = GiftController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.statusFilter == 'pledged' ? 'Pledged Gifts' : 'My Gifts',
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _giftController.fetchGifts(statusFilter: widget.statusFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No gifts found.'));
          } else {
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
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[800],
        onPressed: () {
          Navigator.pushNamed(context, '/addGift'); // Navigate to Add Gift Screen
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

