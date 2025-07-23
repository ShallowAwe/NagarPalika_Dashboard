import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/main.dart';
import 'package:smart_nagarpalika_dashboard/utils/login_container.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> login() async {
      final response = await http.post(
        Uri.parse('http://localhost:8080/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        String username = responseData['username'];
        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate to dashboard after a short delay
        await Future.delayed(const Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDashboard(username: username),
          ),
        );
      } else {
        // Show error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${response.body}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    return Scaffold(
      // backgroundColor must be a Color, so use Container with decoration for gradient
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(colors: gradientColors),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/', height: 100), // Add your logo asset
              SizedBox(height: 20),
              Text(
                'Smart Nagarpalika Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              LoginContainer(
                usernameController: usernameController,
                passwordController: passwordController,
                login: () async {
                  await login();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
