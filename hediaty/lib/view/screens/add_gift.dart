import 'package:flutter/material.dart';
import '/../controllers/gift_controller.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen({super.key});

  @override
  _AddGiftScreenState createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final GiftController _giftController = GiftController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purchaseUrlController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Electronics',
    'Toys',
    'Books',
    'Clothing',
    'Accessories',
    'Home Decor',
    'Beauty & Personal Care',
    'Sports & Fitness',
    'Other',
  ];

  Future<void> _submitGift() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      try {
        await _giftController.addGift(
          name: _nameController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          category: _selectedCategory!,
          description: _descriptionController.text.trim(),
          purchaseUrl: _purchaseUrlController.text.trim().isNotEmpty
              ? _purchaseUrlController.text.trim()
              : null, // Pass null if purchase URL is empty
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gift added successfully!')),
        );
        Navigator.pop(context); // Go back after successful submission
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gift'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Gift Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Gift Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a gift name' : null,
              ),
              const SizedBox(height: 10),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter an image URL' : null,
              ),
              const SizedBox(height: 10),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _purchaseUrlController,
                decoration: const InputDecoration(labelText: 'Purchase URL (optional)'),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return 'Please enter a valid URL';
                    }
                  }
                  return null; // Valid or empty
                },
              ),
              const SizedBox(height: 20),


              ElevatedButton(
                onPressed: _submitGift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Add Gift'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
