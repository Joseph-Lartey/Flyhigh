import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'custom_colors.dart';
import 'api_service.dart';
import 'FlightSelectionPage.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _fromLocation;
  String? _toLocation;
  DateTime? _departDate;
  int? _flexibleDays;

  List<Map<String, dynamic>> locations = [];
  final List<int> flexibleDaysOptions = [0, 1, 2, 3, 4, 5, 6, 7];

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    try {
      final countries = await apiService.fetchCountries();
      setState(() {
        locations = countries;
        if (!locations.any((element) => element['name'] == _fromLocation)) {
          _fromLocation = null;
        }
        if (!locations.any((element) => element['name'] == _toLocation)) {
          _toLocation = null;
        }
      });
    } catch (e) {
      print('Failed to load countries: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _departDate) {
      setState(() {
        _departDate = picked;
      });
    }
  }

Future<void> _searchFlights() async {
  try {
    if (_departDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a departure date.')),
      );
      return;
    }

    if (_departDate!.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a future date.')),
      );
      return;
    }

    final fromLocation = locations.firstWhere(
        (element) => element['name'] == _fromLocation,
        orElse: () => {'id': null})['id'];
    final toLocation = locations.firstWhere(
        (element) => element['name'] == _toLocation,
        orElse: () => {'id': null})['id'];

    print('Searching flights with parameters:');
    print('From: $fromLocation');
    print('To: $toLocation');
    print('Date: ${_departDate?.toIso8601String()}');
    print('Flexible days: $_flexibleDays');

    final response = await apiService.searchFlights({
      'departure_country_id': fromLocation,
      'arrival_country_id': toLocation,
      'departure_date': _departDate?.toIso8601String(),
      'flexible_days': _flexibleDays,
    });

    print('API response: $response');

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FlightSelectionPage(flights: response)),
    );
  } catch (e) {
    print('Failed to search flights: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to search flights: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            expandedHeight: 400,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 380,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/img1.jpg'),
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
        _buildDropdownRow('FROM', 'Select Departure', (String? newValue) {
          setState(() {
            _fromLocation = newValue;
          });
        }, _fromLocation),
        SizedBox(height: 16),
        _buildDropdownRow('TO', 'Select Destination', (String? newValue) {
          setState(() {
            _toLocation = newValue;
          });
        }, _toLocation),
        SizedBox(height: 16),
        _buildDateRow(),
        SizedBox(height: 16),
        _buildFlexibleDaysRow(),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: _searchFlights,
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

  Widget _buildDropdownRow(
      String label, String hint, ValueChanged<String?> onChanged, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDropdown(label, hint, onChanged, value),
        Icon(Icons.flight_takeoff, color: CustomColors.primaryColor),
      ],
    );
  }

  Widget _buildDropdown(
      String label, String hint, ValueChanged<String?> onChanged, String? value) {
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
          value: value,
          hint: Text(hint),
          items: _getDropdownItems(label),
          onChanged: onChanged,
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems(String label) {
    switch (label) {
      case 'FROM':
      case 'TO':
        return locations.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
          return DropdownMenuItem<String>(
            value: value['name'],
            child: Text(value['name']),
          );
        }).toList();
      default:
        return [];
    }
  }

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: CustomColors.primaryColor),
              SizedBox(width: 8),
              Text(
                _departDate == null
                    ? 'Select Date'
                    : '${_departDate!.day}-${_departDate!.month}-${_departDate!.year}',
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSansPro',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlexibleDaysRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Flexible Days',
          style: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceSansPro',
          ),
        ),
        DropdownButton<int>(
          value: _flexibleDays,
          hint: Text('Select Days'),
          items: flexibleDaysOptions.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value days'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _flexibleDays = newValue;
            });
          },
        ),
      ],
    );
  }
}
