import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _registrationSuccess = false;
  bool _loginSuccess = false;
  String? _errorMessage;
  bool isLoading = false;

  User? get user => _user;
  bool? get registrationSuccess => _registrationSuccess;
  bool? get loginSuccess => _loginSuccess;
  String? get errorMessage => _errorMessage;

  // Temporarily store registration details
  Map<String, String> _registrationDetails = {};

  Map<String, String> get registrationDetails => _registrationDetails;

  // Set loading state
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Set registration details
  void setRegistrationDetails(Map<String, String> details) {
    _registrationDetails = details;
    notifyListeners();
  }

  // Clear registration details
  void clearRegistrationDetails() {
    _registrationDetails.clear();
    notifyListeners();
  }

  // User login
Future<void> login(String email, String password) async {
  setLoading(true);
  print('Login started with email: $email and password: $password');

  try {
    final loginResponse = await _authService.login(email, password);
    print('Login response: $loginResponse');

    if (loginResponse['success'] == true) {
      _loginSuccess = true;
      final profileDetails = await _authService.getProfile(loginResponse['id']);
      print('Profile details: $profileDetails');
      _user = User.fromJson(profileDetails);

      // Save user details to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      print('Saving user ID: ${loginResponse['id']}');
      await prefs.setString('userId', loginResponse['id'].toString());
      await prefs.setString('firstName', profileDetails['firstname'] ?? '');
      await prefs.setString('lastName', profileDetails['lastname'] ?? '');
      await prefs.setString('username', profileDetails['username'] ?? '');
      await prefs.setString('email', profileDetails['email'] ?? '');
      await prefs.setString('profilePicturePath', profileDetails['profile_picture_path'] ?? '');
      print('User details saved');
      
    } else {
      _loginSuccess = false;
      _errorMessage = loginResponse['error'];
      print('Login failed: $_errorMessage');
    }
    setLoading(false);
  } catch (e) {
    _loginSuccess = false;
    _errorMessage = e.toString();
    print('Login exception: $_errorMessage');
    setLoading(false);
  }
}

  // User registration
  Future<void> register() async {
    setLoading(true);
    print('Registration started with details: $_registrationDetails');
    try {
      final registerResponse = await _authService.register(
        _registrationDetails['firstname']!,
        _registrationDetails['lastname']!,
        _registrationDetails['username']!,
        _registrationDetails['email']!,
        _registrationDetails['password']!,
      );
      print('Registration response: $registerResponse');

      if (registerResponse['success'] == true) {
        _registrationSuccess = true;
        clearRegistrationDetails(); // Clear registration details after successful registration
      } else {
        _registrationSuccess = false;
        _errorMessage = registerResponse['error'];
        print('Registration failed: $_errorMessage');
      }
      setLoading(false);
    } catch (e) {
      _registrationSuccess = false;
      _errorMessage = e.toString();
      print('Registration exception: $_errorMessage');
      setLoading(false);
    }
  }

  // Update user information
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
