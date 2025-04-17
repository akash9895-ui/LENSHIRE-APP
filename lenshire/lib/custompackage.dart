// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/index.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const AppBarLogo(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Custom Package Request',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Type Dropdown
                      Text(
                        'Service Type',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ServiceType>(
                        value: _selectedServiceType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _serviceTypes.map((type) {
                          return DropdownMenuItem<ServiceType>(
                            value: type,
                            child: Text(
                              type.name,
                              style: AppTextStyles.bodyMedium,
                            ),
                          );
                        }).toList(),
                        onChanged: (ServiceType? newValue) {
                          setState(() {
                            _selectedServiceType = newValue;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a service type' : null,
                      ),
                      // Event Date
                      const SizedBox(height: 16),
                      Text(
                        'Event Date',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.primary),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.error),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.error),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorText: _selectedDate == null &&
                                    _formKey.currentState?.validate() == false
                                ? 'Please select a date'
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Select a date'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: _selectedDate == null
                                      ? AppColors.textHint
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Icon(Icons.calendar_today, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                      // Location
                      const SizedBox(height: 16),
                      Text(
                        'Location',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: AppTextStyles.bodyMedium,
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Please enter a location' : null,
                      ),
                      // Details
                      const SizedBox(height: 16),
                      Text(
                        'Details',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _detailsController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: AppTextStyles.bodyMedium,
                      ),
                      // Duration
                      const SizedBox(height: 16),
                      Text(
                        'Duration (hours)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: AppTextStyles.bodyMedium,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Please enter duration';
                          if (int.tryParse(value!) == null) return 'Enter a valid number';
                          return null;
                        },
                      ),
                      // Budget
                      const SizedBox(height: 16),
                      Text(
                        'Budget (\$)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.error),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: AppTextStyles.bodyMedium,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Please enter budget';
                          if (double.tryParse(value!) == null) return 'Enter a valid amount';
                          return null;
                        },
                      ),
                      // Submit button
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _selectedDate != null) {
                              _submitForm(context);
                            } else {
                              setState(() {
                                // Trigger validation to show date error
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Submit Request',
                            style: AppTextStyles.button,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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

  Future<void> _submitForm(BuildContext context) async {
    try {
      // Get current user ID from Supabase auth
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('You must be logged in to submit a custom package request.');
      }

      // Validate service type
      if (_selectedServiceType == null) {
        throw Exception('Please select a service type.');
      }

      // Parse service_type_id to integer
      final serviceTypeId = int.parse(_selectedServiceType!.id);

      // Parse duration to integer
      final duration = int.parse(_durationController.text);

      // Parse budget to double
      final budget = double.parse(_budgetController.text);

      // Placeholder for photographer_id_id (replace with actual logic if available)
      const photographerId = '968eaf31-c41a-49bd-bab0-111f5719dc41';

      // Prepare request data
      final requestData = {
        'booking_date': DateTime.now().toIso8601String(),
        'event_date': _selectedDate!.toIso8601String(),
        'location': _locationController.text,
        'details': _detailsController.text,
        'duration': duration,
        'budget': budget,
        'custom_status': 0,
        'photographer_id_id': photographerId,
        'service_type_id': serviceTypeId,
        'user_id_id': userId,
      };

      // Log request data for debugging
      print('Request data: $requestData');

      // Insert into User_tbl_custom_package
      await Supabase.instance.client
          .from('User_tbl_custom_package')
          .insert(requestData);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Request Submitted',
            style: AppTextStyles.sectionTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Text(
            'Your custom package request for ${_selectedServiceType!.name} has been submitted successfully.',
            style: AppTextStyles.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: AppTextStyles.actionLink,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Log error for debugging
      print('Request error: $e');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Request Failed',
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: Text(
            'Failed to submit request: $e',
            style: AppTextStyles.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: AppTextStyles.actionLink,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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