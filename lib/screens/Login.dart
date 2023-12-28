import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:green_quest/helpers/AuthUtilities.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/models/User.dart';
import 'package:green_quest/screens/HomeScreen.dart';
import 'package:green_quest/screens/Register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const Gap(20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = true;
                        });
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                TextButton(
                  onPressed: () {
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)),
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
            const Gap(10),
            const Text("Or", style: TextStyle(fontSize: 10)),
            const Gap(10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
              ),
              child: const Text('REGISTER', style: TextStyle(color: Colors.white)),
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not yet Registered?"),
                const Gap(5),
                GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  ),
                  child: const Text("Sign Up", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
  String enteredEmail = _emailController.text.trim();
  String enteredPassword = _passwordController.text.trim();

  // Check if the user exists in the database
  bool isUserExists = await DbHelper.isUserExists(enteredEmail);
if(!isUserExists){
  _showAlertDialog('Error', 'Not registered yet');
}
  if (isUserExists) {
    // Now check if the entered password matches the stored password
    bool isPasswordCorrect = await DbHelper.isPasswordCorrect(enteredEmail, enteredPassword);

    if (isPasswordCorrect) {
  // Fetch the user details from the database
  User? user = await DbHelper.fetchUserByUsername(enteredEmail);

  if (user != null) {
  _showAlertDialog("Login Successfully", "Redirect to Homepage");
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen(userId: user.uid)),
  );
} else {
  _showAlertDialog("Error", "Failed to fetch user details.");
}
} else {
  // If the password is incorrect, show an error message
  _showAlertDialog("Invalid Credentials", "Incorrect password. Please try again.");
}
  }
  }
void _showAlertDialog(String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close AlertDialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
}
