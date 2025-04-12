import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lenshire/login.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/main.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  static const Color primary = Color(0xFF2A9D8F);
  static const Color primaryDark = Color(0xFF1E7168);
  static const Color primaryLight = Color(0xFF4DB6A9);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color containerColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF263238);
  static const Color secondaryTextColor = Color(0xFF607D8B);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final Map<String, dynamic> userData = {
    'name': null,
    'photo': null,
    'email': null,
    'contact': null,
    'address': null,
    'user_id': null,
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final user = supabase.auth.currentUser?.id;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final response = await supabase
          .from('Guest_tbl_user')
          .select()
          .eq('User_id', user)
          .single();

      setState(() {
        userData['name'] = response['user_name'];
        userData['email'] = response['user_email'];
        userData['contact'] = response['user_contact'];
        userData['address'] = response['user_address'];
        userData['photo'] = response['user_photo'];
        userData['user_id'] = response['User_id'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load user data: $e")),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),)); // Adjust route as needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged out successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error logging out: $e")),
        );
      }
    }
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MyProfilePage.primaryTextColor,
            ),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(
                fontSize: 16,
                color: MyProfilePage.secondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 20),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: MyProfilePage.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyProfilePage.backgroundColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: MyProfilePage.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: MyProfilePage.primary))
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Photo and Name
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: MyProfilePage.primaryLight,
                                  backgroundImage: userData['photo'] != null
                                      ? NetworkImage(userData['photo'])
                                      : null,
                                  child: userData['photo'] == null
                                      ? Icon(Icons.person,
                                          size: 60, color: MyProfilePage.primaryDark)
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  userData['name'] ?? "N/A",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: MyProfilePage.primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Profile Details Card
                          Card(
                            color: MyProfilePage.containerColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Profile Details",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: MyProfilePage.primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow("Email", userData['email']),
                                  _buildDetailRow("Contact", userData['contact']),
                                  _buildDetailRow("Address", userData['address']),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action Buttons
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildActionButton(
                                context,
                                "Edit Profile",
                                Icons.edit,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfilePage(userData: userData),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Feedback",
                                Icons.feedback,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FeedbackPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Complaints",
                                Icons.report,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ComplaintsPage(),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                context,
                                "Logout",
                                Icons.logout,
                                _logout,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Edit Profile Page
class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController contactController;
  late TextEditingController addressController;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    contactController = TextEditingController(text: widget.userData['contact']);
    addressController = TextEditingController(text: widget.userData['address']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    addressController.dispose();
    super.dispose();
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

  Future<void> _updateProfile() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        contactController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = widget.userData['photo'];
      if (_selectedImage != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.path.split('/').last}';
        await supabase.storage.from('Userdocs').upload(fileName, _selectedImage!);
        imageUrl = supabase.storage.from('Userdocs').getPublicUrl(fileName);
      }

      await supabase.from('Guest_tbl_user').update({
        'user_name': nameController.text,
        'user_email': emailController.text,
        'user_contact': contactController.text,
        'user_address': addressController.text,
        'user_photo': imageUrl,
      }).eq('User_id', widget.userData['user_id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyProfilePage.backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: MyProfilePage.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: MyProfilePage.primaryLight,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (widget.userData['photo'] != null
                          ? NetworkImage(widget.userData['photo'])
                          : null),
                  child: _selectedImage == null && widget.userData['photo'] == null
                      ? Icon(Icons.camera_alt, color: MyProfilePage.primaryDark)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.person, color: MyProfilePage.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.email, color: MyProfilePage.primary),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                labelText: "Contact",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.phone, color: MyProfilePage.primary),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.location_on, color: MyProfilePage.primary),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyProfilePage.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Feedback Page
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitFeedback() async {
    if (feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.from('Feedback_tbl').insert({
        'user_id': supabase.auth.currentUser?.id,
        'feedback': feedbackController.text,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback submitted successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting feedback: $e")),
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

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyProfilePage.backgroundColor,
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: MyProfilePage.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Enter your feedback",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.feedback, color: MyProfilePage.primary),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyProfilePage.primary,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit Feedback",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Complaints Page
class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final TextEditingController complaintController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitComplaint() async {
    if (complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your complaint")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.from('Complaints_tbl').insert({
        'user_id': supabase.auth.currentUser?.id,
        'complaint': complaintController.text,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint submitted successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting complaint: $e")),
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

  @override
  void dispose() {
    complaintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyProfilePage.backgroundColor,
      appBar: AppBar(
        title: const Text("Complaints"),
        backgroundColor: MyProfilePage.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: complaintController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Enter your complaint",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.report, color: MyProfilePage.primary),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitComplaint,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyProfilePage.primary,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Submit Complaint",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}