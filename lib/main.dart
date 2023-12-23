import 'package:flutter/material.dart';
import 'package:green_quest/screens/splashScreen.dart';

void main(){
  runApp(const GreenQuest());
}
class GreenQuest extends StatelessWidget {
  const GreenQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashLoader(),
    );
  }
}