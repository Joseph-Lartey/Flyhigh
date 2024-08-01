import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'login_page.dart'; 

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/img1.jpg', 
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  const Center(
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Find Your Perfect\nFlight',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Discover the best airlines and deals for your next adventure.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SourceSansPro',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GET STARTED',
                        style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
