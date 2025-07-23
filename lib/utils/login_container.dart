import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  const LoginContainer({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.login,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function login;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Better responsive logic
    double containerWidth;
    double containerHeight;
    double horizontalPadding;
    double verticalPadding;

    if (screenWidth < 600) {
      // Mobile devices
      containerWidth = screenWidth * 0.9; // Use 90% of screen width
      containerHeight = screenHeight * 0.7; // Use 70% of screen height
      horizontalPadding = 24.0;
      verticalPadding = 24.0;
    } else if (screenWidth < 1200) {
      // Tablets
      containerWidth = screenWidth * 0.6;
      containerHeight = screenHeight * 0.6;
      horizontalPadding = 32.0;
      verticalPadding = 32.0;
    } else {
      // Desktop/Large screens
      containerWidth = 480.0; // Fixed width for large screens
      containerHeight = 520.0; // Fixed height for large screens
      horizontalPadding = 40.0;
      verticalPadding = 40.0;
    }

    // Apply minimum and maximum constraints
    containerWidth = containerWidth.clamp(300.0, 500.0);
    containerHeight = containerHeight.clamp(450.0, 600.0);

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 235, 242, 248),
            const Color.fromARGB(255, 211, 227, 243),
            const Color.fromARGB(255, 199, 223, 246),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(204),
            spreadRadius: 4,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo/Icon - responsive size
            CircleAvatar(
              radius: screenWidth < 600 ? 28 : 32,
              backgroundColor: Colors.blue.shade50,
              child: Icon(
                Icons.lock_outline,
                size: screenWidth < 600 ? 32 : 36,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: screenWidth < 600 ? 16 : 20),
            Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: screenWidth < 600 ? 22 : 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "Please sign in to your account",
              style: TextStyle(
                fontSize: screenWidth < 600 ? 14 : 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenWidth < 600 ? 24 : 32),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: screenWidth < 600 ? 12 : 16,
                ),
              ),
            ),
            SizedBox(height: screenWidth < 600 ? 14 : 18),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: screenWidth < 600 ? 12 : 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: screenWidth < 600 ? 13 : 14),
                ),
                child: Text('Forgot password?'),
              ),
            ),
            SizedBox(height: screenWidth < 600 ? 14 : 18),
            SizedBox(
              height: screenWidth < 600 ? 44 : 48,
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: screenWidth < 600 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
