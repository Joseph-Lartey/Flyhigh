import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'custom_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> sendOtp(String email) async {
    final url = Uri.parse('http://16.171.150.101/Flyhigh/backend/user/reset_password');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('OTP Sent'),
              content: const Text(
                'Password reset. Check your email for the new password. You will be required to change your password right after logging in using the new password.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Continue to Login'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(responseData['message']);
      }
    } else {
      showErrorDialog('Failed to send OTP. Please try again.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: CustomColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Icon(
              Icons.email,
              size: 200,
              color: CustomColors.primaryColor,
            ),
            const SizedBox(height: 20),
            const Text(
              'Enter the email address associated with your account and we\'ll send an email with a confirmation to reset your password.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter email',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryColor,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: CustomColors.primaryColor,
                ),
                onPressed: () {
                  final email = _emailController.text;
                  if (email.isNotEmpty) {
                    sendOtp(email);
                  } else {
                    showErrorDialog('Please enter a valid email address.');
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
