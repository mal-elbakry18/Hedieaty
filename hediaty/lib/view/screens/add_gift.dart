/*import 'package:flutter/material.dart';
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
*/


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/gift_controller.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen({super.key});

  @override
  _AddGiftScreenState createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final GiftController _giftController = GiftController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _whereToBuyController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String _selectedCategory = 'General';
  String _localImagePath = ''; // Path for picked image
  bool _isSaving = false;

  final List<String> _categories = [
    'General',
    'Electronics',
    'Clothing',
    'Books',
    'Toys',
    'Food',
  ];

  // Function to pick an image using ImagePicker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _localImagePath = pickedFile.path; // Local file path
        _imageUrlController.text = _generateImageUrl('url.jpg'); // Example image name
      });
    }
  }

  // Function to generate a simple placeholder image URL
  String _generateImageUrl(String filename) {
    return filename; // Static placeholder; replace with real upload logic if needed
  }

  // Function to add a gift
  Future<void> _addGift() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final imageUrl = _localImagePath.isNotEmpty
          ? _generateImageUrl('url.jpg') // Use generated image name
          : _imageUrlController.text.trim(); // Use manual URL if entered

      await _giftController.addGift(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        imageUrl: imageUrl, // Save "url.jpg" or entered URL
        purchaseUrl: _whereToBuyController.text.trim().isNotEmpty
            ? _whereToBuyController.text.trim()
            : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift added successfully!')),
      );
      Navigator.pop(context);
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _whereToBuyController.clear();
    _imageUrlController.clear();
    setState(() {
      _localImagePath = '';
      _selectedCategory = 'General';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gift'),
        backgroundColor: Colors.orange[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Gift Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),

            // Field for Image URL
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 10),

            // Image Picker Button
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
            ),
            const SizedBox(height: 10),

            // Display Picked Image or URL Image
            if (_localImagePath.isNotEmpty) ...[
              Image.file(File(_localImagePath), height: 100, fit: BoxFit.cover),
            ] else if (_imageUrlController.text.isNotEmpty) ...[
              Image.network(
                _imageUrlController.text,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Text('Invalid Image URL'),
              ),
            ] else ...[
              const Center(child: Text('No image selected or added.')),
            ],
            const SizedBox(height: 10),

            // Where to Buy URL
            TextField(
              controller: _whereToBuyController,
              decoration: const InputDecoration(labelText: 'Where to Buy URL (optional)'),
            ),
            const SizedBox(height: 20),

            // Add Gift Button
            Center(
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _addGift,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[800],
                ),
                child: const Text('Add Gift'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
