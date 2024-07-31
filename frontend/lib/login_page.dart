import 'package:flutter/material.dart';
import 'package:frontend/my_flight.dart';
import 'package:provider/provider.dart';
import 'custom_colors.dart';
import 'sign_up.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (authProvider.loginSuccess ?? false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyFlightsPage()),
      );
    } else {
      _showErrorDialog(authProvider.errorMessage ?? 'Login failed');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 80,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'WELCOME TO FLYHIGH',
                          style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Welcome back! Login or sign up to start flying',
                          style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Forgot password?'),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: CustomColors.primaryColor,
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : const Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 140),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
