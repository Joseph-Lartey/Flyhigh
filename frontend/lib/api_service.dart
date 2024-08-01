import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://16.171.150.101/Flyhigh/backend'; // Update this to your actual URL

  Future<List<Map<String, dynamic>>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/countries'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data
            .where((element) =>
                element is Map<String, dynamic> &&
                element['country_id'] != null &&
                element['country_name'] != null)
            .map((element) => {
                  'id': element['country_id'],
                  'name': element['country_name'],
                })
            .toList();
      } else {
        throw Exception(
            'Failed to load countries with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }

Future<List<Map<String, dynamic>>> searchFlights(Map<String, dynamic> params) async {
  final response = await http.post(
    Uri.parse('http://16.171.150.101/Flyhigh/backend/flights/search'),
    body: json.encode(params),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> flightsJson = json.decode(response.body);
    print('Decoded flights: $flightsJson');
    return flightsJson.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to search flights: ${response.statusCode}');
  }
}
}



