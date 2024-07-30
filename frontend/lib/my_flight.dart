import 'package:flutter/material.dart';
import 'custom_colors.dart'; // Adjust the import path as necessary
import 'booking_page.dart';

class MyFlightsPage extends StatelessWidget {
  const MyFlightsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // This extends the body behind the AppBar
      drawer: Drawer(
        // Add your drawer items here
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 370,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/img1.jpg'), // Replace with your image asset
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 16,
                    child: Text(
                      'My Flights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 16,
                    child: Text(
                      'Fly high anytime, to anywhere for anything',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SourceSansPro',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/img3.png'), // Replace with your profile image asset
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Add',
                        style: TextStyle(
                          color: CustomColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro',
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildFlightCard(),
                      SizedBox(height: 16),
                      _buildFlightCard(),
                      SizedBox(height: 16),
                      _buildFlightCard(),
                      SizedBox(height: 16),
                      _buildFlightCard(),
                      SizedBox(height: 16),
                      _buildFlightCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.primaryColor,
        onPressed: () {
          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookingPage()),
                      );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFlightCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFlightDetail('CGK', 'Jakarta'),
                Icon(Icons.flight_takeoff, color: CustomColors.primaryColor),
                _buildFlightDetail('NYC', 'New York City'),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                Text(
                  'Flight No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jan 01, 8:35 PM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                Text(
                  'KB765',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetail(String code, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
        Text(
          city,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'SourceSansPro',
          ),
        ),
      ],
    );
  }
}
