import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:frontend/profile_page.dart';
import 'custom_colors.dart';
import '../services/otpservice.dart';

class OtpVerificationPage extends StatelessWidget {
  final String email;
  const OtpVerificationPage({Key? key, required this.email}) : super(key: key);

  void _verifyOTP(BuildContext context, String otp) {
    if (OTPService.verifyOTP(otp)) {
      // If OTP is verified, navigate to the profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else {
      // If OTP is not verified, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

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
              'OTP has been sent to your e-mail address, please enter the OTP below',
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
              numberOfFields: 6, // Updated to match your OTP length
              borderColor: Color(0xFF512DA8),
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // handle validation or checks here if necessary
              },
              // runs when every textfield is filled
              onSubmit: (String verificationCode) {
                _verifyOTP(context, verificationCode); // handle OTP submission
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Manually get the OTP entered by the user if needed
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
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
