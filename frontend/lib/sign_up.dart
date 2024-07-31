import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';  // Import TapGestureRecognizer
import 'package:provider/provider.dart';
import 'custom_colors.dart';
import 'otp.dart';
import 'login_page.dart';
import '../services/otpservice.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _signUp(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      authProvider.setRegistrationDetails({
        'firstname': _firstNameController.text,
        'lastname': _lastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      OTPService.sendOTP(_emailController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationPage(email: _emailController.text),
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (value.length > 20) {
      return 'Password must be at most 20 characters long';
    }
    RegExp hasUppercase = RegExp(r'[A-Z]');
    RegExp hasLowercase = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    RegExp hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (!hasUppercase.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!hasLowercase.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!hasDigit.hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!hasSpecialChar.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    String pattern = r'^[A-Za-z ]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

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
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Firstname',
                    labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your firstname',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Lastname',
                    labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your lastname',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontFamily: 'SourceSansPro'),
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontFamily: 'SourceSansPro'),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(fontFamily: 'SourceSansPro'),
                    border: const OutlineInputBorder(),
                    hintText: 'Enter your password again',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _signUp(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 5,
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
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Text(
                        'OR',
                        style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: const TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 16,
                            color: CustomColors.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
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
      ),
    );
  }
}
