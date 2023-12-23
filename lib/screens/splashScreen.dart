import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:green_quest/screens/WelcomePage.dart';

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  @override
  _SplashLoaderState createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a welcome screen
    Timer(Duration(seconds: 3), () {
      // Navigate to the home screen after the welcome screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WelcomePage(), // Replace with your HomeScreen widget
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const Gap(20),
            const Text(
              'Welcome to GreenQuest!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            const SpinKitChasingDots(
              color: Colors.green,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
