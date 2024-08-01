import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _profileImage;
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _usernameController.text.isNotEmpty;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(int? userId) async {
    if (_profileImage == null) return;

    final imageExtension = path.extension(_profileImage!.path).replaceAll('.', '');
    final mediaType = MediaType('image', imageExtension);

    final uri = Uri.parse('http://16.171.150.101/Flyhigh/backend/upload/$userId');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
          'profile_image', _profileImage!.path,
          contentType: mediaType));
    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Failed to upload image. Status code: ${response.statusCode}');
      print('Response: $responseBody');
    }
  }

  Future<void> _registerAndNavigateToLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.registrationDetails['email'];
    final firstname = authProvider.registrationDetails['firstname'];
    final lastname = authProvider.registrationDetails['lastname'];
    final username = _usernameController.text; // Updated to get the username from the controller
    final password = authProvider.registrationDetails['password'];
    final confirmPassword = password; // Assuming confirmPassword is the same as password for this context

    print('Attempting registration with email: $email, username: $username');
    print(
        'Registration details - firstname: $firstname, lastname: $lastname, password: $password, confirmPassword: $confirmPassword');

    if (email != null &&
        password != null &&
        firstname != null &&
        lastname != null &&
        username.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://16.171.150.101/Flyhigh/backend/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirm_password': confirmPassword, // Ensure confirmPassword is sent in the registration request
          'firstname': firstname,
          'lastname': lastname,
          'username': username,
        }),
      );
      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          // Registration successful, navigate to login page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your login page
          );
        } else {
          print('Registration failed!');
        }
      } else {
        print('Registration request failed!');
      }
    } else {
      print('Required registration details are missing!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Who Are ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "YOU?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Enter your details to set up your profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _showImageSourceActionSheet(context);
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(
                            Icons.camera_alt,
                            color: Colors.grey[700],
                            size: 30,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              onPressed: _isButtonActive ? _registerAndNavigateToLogin : null,
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
