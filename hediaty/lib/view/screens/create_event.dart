/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final EventController _eventController = EventController();

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

  // Handle Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Handle Event Creation
  Future<void> _createEvent(BuildContext context, bool isPublished) async {
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _selectedDate == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all the required details!')),
      );
      return;
    }

    try {
      await _eventController.createEvent(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate!,
        category: _selectedCategory!,
        isPublished: isPublished,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event created successfully!')),
      );

      // Navigate to events page
      Navigator.pushReplacementNamed(context, '/events');
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
        title: Text('Create New Event'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),

              // Event Description Field
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),

              // Event Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                            : 'Select Date',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Buttons for Adding Gifts or Saving Event
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _createEvent(context, false), // Save without publishing
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: Text('Add Gifts Later'),
                  ),
                  ElevatedButton(
                    onPressed: () => _createEvent(context, true), // Publish with/without gifts
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: Text('Publish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final EventController _eventController = EventController();

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

  // Show Date Picker
  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Create or Publish Event
  Future<void> _createEvent(bool isPublished) async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final date = _selectedDate;
    final category = _selectedCategory;

    if (!_eventController.validateEvent(
      name: name,
      description: description,
      date: date,
      category: category,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the required details!')),
      );
      return;
    }

    try {
      await _eventController.createEvent(
        name: name,
        description: description,
        date: date!,
        category: category!,
        isPublished: isPublished,
      );

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isPublished ? 'Event published!' : 'Event saved!')));
      Navigator.pushReplacementNamed(context, '/events');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFF3E0),
                ),
              ),
              SizedBox(height: 15),

              // Event Description
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFF3E0),
                ),
              ),
              SizedBox(height: 15),

              // Event Date Picker
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFFFF3E0),
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
              SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFFFF3E0),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _createEvent(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: Text('Add Gifts Later'),
                  ),
                  ElevatedButton(
                    onPressed: () => _createEvent(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: Text('Publish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final EventController _eventController = EventController();

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

  // Show Date Picker
  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Create or Publish Event
  Future<void> _createEvent(bool isPublished) async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final date = _selectedDate;
    final category = _selectedCategory;

    // Validate Event Details
    if (!_eventController.validateEvent(
      name: name,
      description: description,
      date: date,
      category: category,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the required details!')),
      );
      return;
    }

    try {
      // Create Event
      await _eventController.createEvent(
        name: name,
        description: description,
        date: date!,
        category: category!,
        isPublished: isPublished,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isPublished ? 'Event published!' : 'Event saved!'),
      ));

      // Navigate back to Events Page
      Navigator.pushReplacementNamed(context, '/events');
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
        title: const Text('Create Event'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                onTap: _selectDate,
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

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _createEvent(false), // Save without publishing
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: const Text('Add Gifts Later'),
                  ),
                  ElevatedButton(
                    onPressed: () => _createEvent(true), // Publish the event
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: const Text('Publish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/controllers/events_controller.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final EventController _eventController = EventController();

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

  // Show Date Picker
  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Create or Publish Event
  Future<void> _createEvent(bool isPublished) async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final date = _selectedDate;
    final category = _selectedCategory;

    // Validate Event Details
    if (!_eventController.validateEvent(
      name: name,
      description: description,
      date: date,
      category: category,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the required details!')),
      );
      return;
    }

    try {
      // Fetch the `creatorId`
      final creatorId = await _eventController.getCurrentUserId();
      if (creatorId == null) {
        throw Exception("Unable to fetch creator ID. Make sure the user is logged in.");
      }

      // Create Event
      await _eventController.createEvent(
        name: name,
        description: description,
        date: date!,
        category: category!,
        isPublished: isPublished,
       // creatorId: creatorId, // Pass the fetched creatorId
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isPublished ? 'Event published!' : 'Event saved!'),
      ));

      // Navigate back to Events Page
      Navigator.pushReplacementNamed(context, '/events');
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
        title: const Text('Create Event'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                onTap: _selectDate,
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

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _createEvent(false), // Save without publishing
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: const Text('Add Gifts Later'),
                  ),
                  ElevatedButton(
                    onPressed: () => _createEvent(true), // Publish the event
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    child: const Text('Publish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
