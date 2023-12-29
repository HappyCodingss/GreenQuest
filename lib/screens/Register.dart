import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/models/User.dart';
import 'package:green_quest/screens/Login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height:80),
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                const Gap(20),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    labelText: 'ImageURL',
                    icon: Icon(Icons.image),
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
                        const Text('I agree to the terms and conditions'),
                      ],
                    ),
                    
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _signUp();
                    },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4CAF50)),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 50)),
                  ),
                  child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already Have An Account?"),
                    const Gap(5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text("Login", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 void _signUp() async {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();
  String confirmPassword = _confirmPasswordController.text.trim();
  String image = _imageController.text.trim();

  if(!isChecked){
    _showAlertDialog("Attention!", "Please agree to our terms and conditions before proceeding!");
  }
  if (password == confirmPassword) {
    if (await DbHelper.isUserExists(username)) {
      _showAlertDialog("Username Exists", "The username is already signed up.");
    } else {
      User newUser = User(username: username, password: password, points: 0, imageUrl: image);
      DbHelper.insertUser(newUser);
      
      // Show AlertDialog and handle navigation in its callback
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("You are successfully signed up!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close AlertDialog
                  // Redirect to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } else {
    _showAlertDialog("Password Mismatch", "Check the details before proceeding");
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
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
