import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_colors.dart';
import 'my_flight.dart'; // Import MyFlightsPage

class FlightSelectionPage extends StatelessWidget {
  final List<Map<String, dynamic>> flights;

  const FlightSelectionPage({Key? key, required this.flights}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${flight['airline']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Flight ${flight['flight_number']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildAirportInfo(flight['departure_airport'], _formatTime(flight['departure_time'])),
                        ),
                        Icon(Icons.flight_takeoff, color: CustomColors.primaryColor),
                        Expanded(
                          child: _buildAirportInfo(flight['arrival_airport'], _formatTime(flight['arrival_time'])),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Duration: ${flight['duration']} hours',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildPriceRow('Business', flight['price_business'].toString(), flight['seats_business']),
                    _buildPriceRow('Economy', flight['price_economy'].toString(), flight['seats_economy']),
                    _buildPriceRow('Elite', flight['price_elite'].toString(), flight['seats_elite']),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _bookFlight(flight, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        ),
                        child: Text(
                          'Book',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAirportInfo(String airport, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          airport,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String className, String price, int seatsAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$className: \$$price',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$seatsAvailable seats left',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeString) {
    final format = DateFormat.Hms(); // Time format HH:mm:ss
    final time = format.parse(timeString);
    return DateFormat('HH:mm').format(time);
  }

  Future<void> _bookFlight(Map<String, dynamic> flight, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Use the correct key
    if (userId == null) {
      // Handle the error if the user_id is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID not found')),
      );
      return;
    }

    final payload = {
      "user_id": int.parse(userId), // Convert to int if needed
      "template_id": flight['template_id'],
      "departure_country_id": flight['departure_country_id'],
      "arrival_country_id": flight['arrival_country_id'],
    };

    final url = 'http://16.171.150.101/Flyhigh/backend/flights/book';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      // Handle successful booking
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful')),
      );

      // Navigate to MyFlightsPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyFlightsPage()),
      );
    } else {
      // Handle booking failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${response.body}')),
      );
    }
  }
}
