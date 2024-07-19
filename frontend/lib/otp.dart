import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:frontend/profile_page.dart';
import 'custom_colors.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'USER VERIFICATION',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'OTP has been sent to your e-mail address, please enter the OTP in the bottom',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            const Icon(Icons.lock_outline, size: 50),
            const SizedBox(height: 30),
            OtpTextField(
              numberOfFields: 4,
              borderColor: Color(0xFF512DA8),
              // set to true to show as box or false to show as dash
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // handle validation or checks here if necessary
              },
              // runs when every textfield is filled
              onSubmit: (String verificationCode) {
                // handle OTP submission
              }, // end onSubmit
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor, // Background color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: const TextStyle(
                  color: Colors.white, // Text color
                  fontFamily: 'SourceSansPro',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'VERIFY',
                style: TextStyle(color: Colors.white), // Ensure text color is white
              ),
            ),
          ],
        ),
      ),
    );
  }
} 