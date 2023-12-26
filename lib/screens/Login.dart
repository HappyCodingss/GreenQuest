import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:green_quest/screens/HomeScreen.dart';
import 'package:green_quest/screens/Register.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo or image here
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const Gap(20),
            // Add your login form fields (text fields, email, password, etc.)
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true, // For password fields
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      // Add your logic for handling the checkbox state
                      value: false,
                      onChanged: (value) {
                        // Handle checkbox state change
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Add your "Forgot Password" logic here
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your login logic here
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)), // Custom button color
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)), // Set the button width to be as wide as the screen
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
            const Gap(10),
            const Text("Or", style: TextStyle(fontSize: 10)),
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                // Add your login via Google logic here
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Custom button color for Google
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)), // Set the button width to be as wide as the screen
              ),
              child: const Text('Login via Google', style: TextStyle(color: Colors.white)),
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not yet Registered?"),
                const Gap(5),
            GestureDetector(
              onTap: ()=>RegisterScreen(),
              child: Text("Sign Up", style: TextStyle(color: Colors.blue)),
            ) ],
            ),
          ],
        ),
      ),
    );
  }
}
