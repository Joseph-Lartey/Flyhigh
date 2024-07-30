import 'package:flutter/material.dart';
import 'custom_colors.dart'; // Adjust the import path as necessary

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _fromLocation;
  String? _toLocation;
  DateTime? _departDate;
  DateTime? _returnDate;
  int _passengers = 1;
  int _luggage = 3;
  String _class = 'Economy';

  final List<String> locations = ['Surabaya', 'London City', 'New York', 'Tokyo', 'Paris'];
  final List<String> classes = ['Economy', 'Business', 'Elite'];

  Future<void> _selectDate(BuildContext context, bool isDepart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (_departDate ?? _returnDate))
      setState(() {
        if (isDepart) {
          _departDate = picked;
        } else {
          _returnDate = picked;
        }
      });
  }

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
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
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
                      'Book your Flight',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                      // Flight booking form
                      _buildFlightBookingForm(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightBookingForm() {
    return Column(
      children: [
        _buildDropdownRow('FROM', 'Surabaya', (String? newValue) {
          setState(() {
            _fromLocation = newValue;
          });
        }),
        SizedBox(height: 16),
        _buildDropdownRow('TO', 'London City', (String? newValue) {
          setState(() {
            _toLocation = newValue;
          });
        }),
        SizedBox(height: 16),
        _buildDateRow(),
        SizedBox(height: 16),
        _buildPassengerLuggageRow(),
        SizedBox(height: 16),
        _buildClassRow(),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Search Flights',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'SourceSansPro',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(String label, String hint, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdown(label, hint, onChanged),
        Icon(Icons.flight_takeoff, color: CustomColors.primaryColor),
      ],
    );
  }

  Widget _buildDropdown(String label, String hint, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
        SizedBox(height: 4),
        DropdownButton<String>(
          value: label == 'FROM' ? _fromLocation : _toLocation,
          hint: Text(hint),
          items: locations.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildDateDetail('DEPART', _departDate),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildDateDetail('RETURN', _returnDate),
        ),
      ],
    );
  }

  Widget _buildDateDetail(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectDate(context, label == 'DEPART'),
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  date != null ? '${date.day}/${date.month}/${date.year}' : 'DD/MM/YY',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerLuggageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildPassengerDetail('PASSENGER', _passengers),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildLuggageDetail('LUGGAGE', _luggage),
        ),
      ],
    );
  }

  Widget _buildPassengerDetail(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.person, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: value,
              items: List.generate(10, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _passengers = newValue!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLuggageDetail(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.luggage, size: 20, color: Colors.grey),
            SizedBox(width: 8),
            DropdownButton<int>(
              value: value,
              items: List.generate(10, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value KGs'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _luggage = newValue!;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClassRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: classes.map((String label) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _class = label;
            });
          },
          child: _buildClassDetail(label),
        );
      }).toList(),
    );
  }

  Widget _buildClassDetail(String label) {
    return Text(
      label,
      style: TextStyle(
        color: label == _class ? CustomColors.primaryColor : Colors.black,
        fontSize: 16,
        fontFamily: 'SourceSansPro',
      ),
    );
  }
}
