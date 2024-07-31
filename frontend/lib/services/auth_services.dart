import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://16.171.150.101/N.A.C.K/backend";

  // Register users
  Future<Map<String, dynamic>> register(String firstname, String lastname,
      String username, String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': password,
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
      final responseBody = jsonDecode(response.body);
      if (responseBody['success'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', responseBody['id']);
        await prefs.setString('email', email);
      }
      return responseBody;
    }
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

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }

  // Log out user
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');
  }

  // Get userId from shared preferences
  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
