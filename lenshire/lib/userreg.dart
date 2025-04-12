import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class HtmlStyleRegistrationPage extends StatefulWidget {
  const HtmlStyleRegistrationPage({super.key});

  @override
  State<HtmlStyleRegistrationPage> createState() => _HtmlStyleRegistrationPageState();
}

class _HtmlStyleRegistrationPageState extends State<HtmlStyleRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Map<String, dynamic>? _selectedDistrict;
  Map<String, dynamic>? _selectedPlace;
  List<Map<String, dynamic>> _districts = [{'id': null, 'name': 'Select'}];
  List<Map<String, dynamic>> _places = [{'id': null, 'name': 'Select'}];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDistricts();
  }

  Future<void> _fetchDistricts() async {
    try {
      final response = await Supabase.instance.client
          .from('Admin_tbl_district')
          .select('id, district_name');

      setState(() {
        _districts = [
          {'id': null, 'name': 'Select'},
          ...response.map((e) => {'id': e['id'], 'name': e['district_name']})
        ];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching districts: $e')),
        );
      }
    }
  }

  Future<void> _fetchPlaces(int districtId) async {
    try {
      final response = await Supabase.instance.client
          .from('Admin_tbl_place')
          .select('id, place_name')
          .eq('district_id', districtId);

      setState(() {
        _places = [
          {'id': null, 'name': 'Select'},
          ...response.map((e) => {'id': e['id'], 'name': e['place_name']})
        ];
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching places: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null && mounted) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Upload image to Supabase storage
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.path.split('/').last}';
        await Supabase.instance.client.storage
            .from('Userdocs')
            .upload(fileName, _selectedImage!);

        final imageUrl = Supabase.instance.client.storage
            .from('Userdocs')
            .getPublicUrl(fileName);

        // Register user with Supabase Auth
        final authResponse = await Supabase.instance.client.auth.signUp(
          email: emailController.text,
          password: passwordController.text,
        );

        if (authResponse.user == null) {
          throw 'Authentication failed';
        }

        final userId = authResponse.user!.id;

        // Insert user data into Guest_tbl_user
        await Supabase.instance.client.from('Guest_tbl_user').insert({
          'User_id': userId,
          'user_name': nameController.text,
          'user_email': emailController.text,
          'user_contact': contactController.text,
          'user_address': addressController.text,
          
          'user_password': passwordController.text,
          'place_id': _selectedPlace!['id'],
          'user_photo': imageUrl,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );

          // Clear form
          _formKey.currentState?.reset();
          setState(() {
            _selectedImage = null;
            _selectedDistrict = null;
            _selectedPlace = null;
            _places = [{'id': null, 'name': 'Select'}];
            nameController.clear();
            emailController.clear();
            contactController.clear();
            addressController.clear();
            passwordController.clear();
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    addressController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "User Registration",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF444444),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Name Field
                  _buildFormGroup(
                    label: "Name",
                    child: TextFormField(
                      controller: nameController,
                      decoration: _buildInputDecoration(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (!RegExp(r'^[A-Z][a-zA-Z ]*$').hasMatch(value)) {
                          return 'First letter must be uppercase';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Email Field
                  _buildFormGroup(
                    label: "Email",
                    child: TextFormField(
                      controller: emailController,
                      decoration: _buildInputDecoration(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Contact Field
                  _buildFormGroup(
                    label: "Contact",
                    child: TextFormField(
                      controller: contactController,
                      decoration: _buildInputDecoration(),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^[7-9][0-9]{9}$').hasMatch(value)) {
                          return 'Phone must start with 7-9 and be 10 digits';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Address Field
                  _buildFormGroup(
                    label: "Address",
                    child: TextFormField(
                      controller: addressController,
                      decoration: _buildInputDecoration(),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Password Field
                  _buildFormGroup(
                    label: "Password",
                    child: TextFormField(
                      controller: passwordController,
                      decoration: _buildInputDecoration(),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$').hasMatch(value)) {
                          return 'Must contain at least one number, uppercase and lowercase letter, and be 8+ characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  // District Dropdown
                  _buildFormGroup(
                    label: "District",
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedDistrict,
                      decoration: _buildInputDecoration(),
                      items: _districts.map((district) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: district,
                          child: Text(district['name']),
                        );
                      }).toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _selectedDistrict = value;
                                _selectedPlace = null;
                                _places = [{'id': null, 'name': 'Select'}];
                              });
                              if (value != null && value['id'] != null) {
                                _fetchPlaces(value['id']);
                              }
                            },
                      validator: (value) {
                        if (value == null || value['id'] == null) {
                          return 'Please select a district';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Place Dropdown
                  _buildFormGroup(
                    label: "Place",
                    child: DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedPlace,
                      decoration: _buildInputDecoration(),
                      items: _places.map((place) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: place,
                          child: Text(place['name']),
                        );
                      }).toList(),
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _selectedPlace = value;
                              });
                            },
                      validator: (value) {
                        if (value == null || value['id'] == null) {
                          return 'Please select a place';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Photo Upload
                  _buildFormGroup(
                    label: "Photo",
                    child: InkWell(
                      onTap: _isLoading ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFCCCCCC)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                _selectedImage == null
                                    ? "Select an image"
                                    : _selectedImage!.path.split('/').last,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.upload, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Button Group
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFA726),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  _formKey.currentState?.reset();
                                  setState(() {
                                    _selectedImage = null;
                                    _selectedDistrict = null;
                                    _selectedPlace = null;
                                    _places = [{'id': null, 'name': 'Select'}];
                                    nameController.clear();
                                    emailController.clear();
                                    contactController.clear();
                                    addressController.clear();
                                    passwordController.clear();
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCCCCCC),
                            foregroundColor: const Color(0xFF333333),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormGroup({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFFFFA726)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}