// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ServiceType {
  final String id;
  final String name;

  ServiceType({required this.id, required this.name});
}

class CustomPackageRequestPage extends StatefulWidget {
  const CustomPackageRequestPage({super.key});

  @override
  _CustomPackageRequestPageState createState() => _CustomPackageRequestPageState();
}

class _CustomPackageRequestPageState extends State<CustomPackageRequestPage> {
  final List<ServiceType> _serviceTypes = [
    ServiceType(id: '1', name: 'Wedding'),
    ServiceType(id: '2', name: 'Portrait'),
    ServiceType(id: '3', name: 'Event'),
  ];

  ServiceType? _selectedServiceType;
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Package Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Service Type Dropdown
              DropdownButtonFormField<ServiceType>(
                value: _selectedServiceType,
                decoration: InputDecoration(
                  labelText: 'Service Type',
                  border: OutlineInputBorder(),
                ),
                items: _serviceTypes.map((type) {
                  return DropdownMenuItem<ServiceType>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (ServiceType? newValue) {
                  setState(() {
                    _selectedServiceType = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a type' : null,
              ),

              const SizedBox(height: 20),

              // Event Date
              InkWell(
                onTap: () => _selectDate(context), // Pass context here
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Event Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select a date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a location' : null,
              ),

              const SizedBox(height: 20),

              // Details
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              // Duration
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duration (hours)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter duration';
                  if (int.tryParse(value!) == null) return 'Enter valid number';
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Budget
              TextFormField(
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: 'Budget (\$)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter budget';
                  if (double.tryParse(value!) == null) return 'Enter valid amount';
                  return null;
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _submitForm(context), // Pass context here
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm(BuildContext context) { // Accept context as parameter
    if (_formKey.currentState!.validate()) {
      // Form is valid - process data
      final requestData = {
        'service_type': _selectedServiceType?.name,
        'date': _selectedDate,
        'location': _locationController.text,
        'details': _detailsController.text,
        'duration': _durationController.text,
        'budget': _budgetController.text,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted: $requestData')),
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _detailsController.dispose();
    _durationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }
}