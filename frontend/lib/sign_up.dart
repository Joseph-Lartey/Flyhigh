import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Add this line
import 'custom_colors.dart';
import 'otp.dart'; 

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(fontFamily: 'SourceSansPro')),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/images/logo.png', height: 50),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'WELCOME TO FLYHIGH',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Welcome back! Login or sign up to start flying',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Firstname',
                  labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your firstname',
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Lastname',
                  labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your lastname',
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password again',
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OtpVerificationPage()),
                      );
                    // Handle login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal:150,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children:  [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/images/google.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Handle Google sign in
                    },
                  ),
                  const SizedBox(width: 100),
                  IconButton(
                    icon: Image.asset('assets/images/apple.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Handle Apple sign in
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: const TextStyle(
                      fontFamily: 'SourceSansPro',
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text: 'Sign up',
                        style: const TextStyle(
                          fontFamily: 'SourceSansPro',
                          color: CustomColors.primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle sign up
                          },
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
}
