import 'package:flutter/material.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/screens/splashScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initTasks(); 
  await DbHelper.insertFixedTasks(DbHelper.fixedTasks); 
  await DbHelper.openDB();
  await DbHelper.initTrees();
  runApp(GreenQuest());
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