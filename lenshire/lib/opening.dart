import 'package:flutter/material.dart';
import 'package:lenshire/login.dart';
import 'package:lenshire/userreg.dart';

class OpeningPage extends StatelessWidget {
  const OpeningPage({super.key});

  // Color scheme with distinct gradient background
  static const Color backgroundGradientStart = Color(0xFFF5E8C7); // Warm beige
  static const Color backgroundGradientEnd = Color(0xFF93B5C6);   // Soft blue-gray
  static const Color containerColor = Colors.white;
  static const Color buttonColor = Color(0xFFFFA726);
  static const Color primaryTextColor = Color(0xFF444444);
  static const Color secondaryTextColor = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 251, 250, 249),
              Color.fromARGB(255, 243, 207, 79),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Changed font type to Roboto
                  color: primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "LensHire",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Matching font type
                  color: primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Find and hire the best photographers",
                style: TextStyle(
                  fontSize: 18,
                  color: secondaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: buttonColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18, color: buttonColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}