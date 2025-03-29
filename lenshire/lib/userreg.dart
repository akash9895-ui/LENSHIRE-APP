import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lenshire/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  XFile? _selectedImage;

  // Color constants
  static const Color backgroundColor = Color(0xFFF2F2F2);
  static const Color containerColor = Colors.white;
  static const Color inputFillColor = Color(0xFFF9F9F9);
  static const Color borderColor = Color(0xFFCCCCCC);
  static const Color primaryTextColor = Color(0xFF444444);
  static const Color secondaryTextColor = Color(0xFF666666);
  static const Color buttonColor = Color(0xFFFFA726);

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: backgroundColor,
                          
                          child: _selectedImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: secondaryTextColor,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo, color: buttonColor),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    icon: Icons.person,
                    hint: "Username",
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.email,
                    hint: "Email",
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.lock,
                    hint: "Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    icon: Icons.lock,
                    hint: "Confirm Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: secondaryTextColor, fontSize: 13),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push( context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: buttonColor,
                            fontWeight: FontWeight.w600,
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

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: secondaryTextColor),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: buttonColor),
        ),
      ),
    );
  }
}
