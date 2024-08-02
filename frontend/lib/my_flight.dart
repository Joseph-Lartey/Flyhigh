import 'package:flutter/material.dart';
import 'package:frontend/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'custom_colors.dart';
import 'booking_page.dart';
import 'userprofile.dart';

class MyFlightsPage extends StatefulWidget {
  const MyFlightsPage({Key? key}) : super(key: key);

  @override
  _MyFlightsPageState createState() => _MyFlightsPageState();
}

class _MyFlightsPageState extends State<MyFlightsPage> {
  String _firstName = '';
  String _lastName = '';
  List _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _fetchUserBookings();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
    });
  }

Future<void> _fetchUserBookings() async {
  final prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('userId'); // Retrieve as int

  if (userId != null) {
    String userIdString = userId.toString(); // Convert to string
    try {
      final response = await http.get(Uri.parse('http://16.171.150.101/Flyhigh/backend/bookings/$userIdString'));

      if (response.statusCode == 200) {
        setState(() {
          _bookings = json.decode(response.body);
        });
      } else {
        print('Failed to load bookings. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  } else {
    print('User ID not found in SharedPreferences or is empty');
    // Handle the case where user ID is not available
    // You might want to navigate to the login page or show an error message
  }
}


  Future<void> _refreshBookings() async {
    setState(() {
      _bookings.clear();
    });
    await _fetchUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: CustomColors.primaryColor,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/img3.png'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$_firstName $_lastName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: CustomColors.primaryColor),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.flight, color: CustomColors.primaryColor),
              title: const Text('Book a Flight'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingPage()),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBookings,
        child: CustomScrollView(
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
                          image: AssetImage('assets/images/img2.jpg'),
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
                    backgroundImage: AssetImage('assets/images/img3.png'),
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
                        ..._buildFlightCards(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  List<Widget> _buildFlightCards() {
    return _bookings.map((booking) => _buildFlightCard(booking)).toList();
  }

  Widget _buildFlightCard(Map booking) {
    // Fetch departure and arrival country names
    String departureCountryName = booking['departure_country_name'] ?? 'Unknown Departure';
    String arrivalCountryName = booking['arrival_country_name'] ?? 'Unknown Arrival';
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFlightDetail(departureCountryName),
                Icon(Icons.flight_takeoff, color: CustomColors.primaryColor),
                _buildFlightDetail(arrivalCountryName),
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
                  booking['booking_date'] ?? 'Unknown Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                Text(
                  booking['flight_number'] ?? 'Unknown Flight No',
                  style: TextStyle(
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

  Widget _buildFlightDetail(String countryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          countryName,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
      ],
    );
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () async {
                await _clearCredentials();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
