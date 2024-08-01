import 'package:flutter/material.dart';
import 'custom_colors.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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
                        Text(
                          '${flight['airline']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryColor,
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
                        _buildAirportInfo(flight['departure_airport'], _formatDateTime(flight['departure_time'])),
                        Icon(Icons.flight_takeoff, color: CustomColors.primaryColor),
                        _buildAirportInfo(flight['arrival_airport'], _formatDateTime(flight['arrival_time'])),
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
                    _buildPriceRow('Business', flight['price_business'], flight['seats_available_business']),
                    _buildPriceRow('Economy', flight['price_economy'], flight['seats_available_economy']),
                    _buildPriceRow('Elite', flight['price_elite'], flight['seats_available_elite']),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle flight selection
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        ),
                        child: Text(
                          'Book',
                          style: TextStyle(fontSize: 16),
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
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
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
            ),
          ),
          Text(
            '$seatsAvailable seats left',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('MMM d, HH:mm').format(dateTime);
  }
}