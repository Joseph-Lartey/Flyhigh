import 'package:flutter/material.dart';
import 'custom_colors.dart';  // Adjust the import path as necessary

class ProfilePage extends StatelessWidget {
    const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.primaryColor),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WHO ARE YOU?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryColor,
                fontFamily: 'SourceSansPro',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your details to set up your profile",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'SourceSansPro',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: IconButton(
                   icon: const Icon(Icons.camera_alt, color: CustomColors.primaryColor, size: 30),
                  onPressed: () {
                    // Handle profile picture upload
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: const TextStyle(fontFamily: 'SourceSansPro'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text('Choose birthday date'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontFamily: 'SourceSansPro'),
              ),
              onPressed: () {
                // Handle date picker
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('CONTINUE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontFamily: 'SourceSansPro'),
              ),
              onPressed: () {
                // Handle continue button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
