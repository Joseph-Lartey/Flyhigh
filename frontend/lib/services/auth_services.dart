import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://16.171.150.101/N.A.C.K/backend";

  // Register users
  Future<Map<String, dynamic>> register(String firstname, String lastname,
      String username, String email, String password, String dob) async {
    final response = await http.post(Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': password,
          'dob': dob
        }));

    if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      return jsonDecode(response.body);
    }
  }

  // Log users into the application
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      final data = jsonDecode(response.body);

      // Save user data to local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', data['id'].toString());

      return data;
    }
  }

  // Logout users
  Future<void> logout() async {
    // Remove user data from local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  // Get the profile details of a user
  Future<Map<String, dynamic>> getProfile(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get profile");
    }
  }

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    return userId != null;
  }
}
