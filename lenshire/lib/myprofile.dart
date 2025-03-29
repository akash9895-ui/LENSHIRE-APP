import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
   MyProfilePage({super.key});

  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color containerColor = Colors.white;
  static const Color buttonColor = Color(0xFFFFA726);
  static const Color primaryTextColor = Color(0xFF444444);
  static const Color secondaryTextColor = Color(0xFF666666);

  // Mock user data (replace with actual data from API)
  final Map<String, dynamic> userData = {
    'user_id': 'U12345',
    'user_name': 'John Doe',
    'user_email': 'john.doe@example.com',
    'user_contact': '+1234567890',
    'user_address': '123 Main St, City, Country',
    'user_password': '********', // Masked for security
    'place': 'New York', // Assuming place is a string representation
    'user_photo': 'https://example.com/user_photo.jpg', // URL for user photo
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: buttonColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo and Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(userData['user_photo']),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Fallback if the image fails to load
                        const Icon(Icons.person, size: 60, color: Colors.grey);
                      },
                      child: userData['user_photo'] == null
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['user_name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "User ID: ${userData['user_id']}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Profile Details Card
              Card(
                color: containerColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow("Email", userData['user_email']),
                      _buildDetailRow("Contact", userData['user_contact']),
                      _buildDetailRow("Address", userData['user_address']),
                      _buildDetailRow("Place", userData['place']),
                      _buildDetailRow("Password", userData['user_password']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    "Edit Profile",
                    Icons.edit,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(userData: userData),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: secondaryTextColor,
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
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
  late TextEditingController passwordController;
  late TextEditingController placeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['user_name']);
    emailController = TextEditingController(text: widget.userData['user_email']);
    contactController = TextEditingController(text: widget.userData['user_contact']);
    addressController = TextEditingController(text: widget.userData['user_address']);
    passwordController = TextEditingController(text: widget.userData['user_password']);
    placeController = TextEditingController(text: widget.userData['place']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    addressController.dispose();
    passwordController.dispose();
    placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: MyProfilePage.buttonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: "Contact",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: "Place",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add logic to update profile (e.g., API call)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated successfully")),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyProfilePage.buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Feedback Page
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
        backgroundColor: MyProfilePage.buttonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Enter your feedback",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (feedbackController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feedback submitted successfully")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your feedback")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyProfilePage.buttonColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
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
class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController complaintController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints"),
        backgroundColor: MyProfilePage.buttonColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: complaintController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Enter your complaint",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (complaintController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Complaint submitted successfully")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your complaint")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyProfilePage.buttonColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
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