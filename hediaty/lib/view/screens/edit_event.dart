import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class EditEventScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EditEventScreen({super.key, required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final EventController _eventController = EventController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = [
    'Birthday',
    'Weddings',
    'Graduation',
    'Anniversary',
    'Engagement',
    'Baby Shower',
    'Festival',
    'Party',
    'Official Holidays',
    'Bachelor Party',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.event['name'] ?? '';
    _descriptionController.text = widget.event['description'] ?? '';
    _selectedDate = DateTime.tryParse(widget.event['date']);
    _selectedCategory = widget.event['category'];
  }

  Future<void> _updateEvent() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty || _selectedCategory == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
      return;
    }

    try {
      await _eventController.editEvent(
        eventId: widget.event['id'],
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate!,
        category: _selectedCategory!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
  bool _isPublic = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFF3E0), // Creamy background
                ),
              ),
              const SizedBox(height: 15),


                SwitchListTile(
                title: const Text('Make Public'),
                value: _isPublic,
                onChanged: (bool value) {
                  setState(() {
                    _isPublic = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              // Event Description Field
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFF3E0), // Creamy background
                ),
              ),
              const SizedBox(height: 15),

              // Event Date Picker
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFFF3E0), // Creamy background
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('MMM dd, yyyy').format(_selectedDate!)
                            : 'Select Date',
                        style: TextStyle(fontSize: 16, color: Colors.orange[800]),
                      ),
                      Icon(Icons.calendar_today, color: Colors.orange[800]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFF3E0), // Creamy background
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Update Button
              Center(
                child: ElevatedButton(
                  onPressed: _updateEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                  ),
                  child: const Text('Update Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
