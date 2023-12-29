import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:green_quest/screens/HomeScreen.dart';
import 'package:green_quest/screens/Tasks.dart';
import 'package:green_quest/screens/Trees.dart';

class MyAppBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int userId;

  MyAppBottomNavigationBar({required this.currentIndex, required this.onTap, required this.userId});

  @override
  _MyAppBottomNavigationBarState createState() => _MyAppBottomNavigationBarState();
}

class _MyAppBottomNavigationBarState extends State<MyAppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        // Call the onTap function provided by the parent
        widget.onTap(index);

        // Handle navigation to different screens based on index
        switch (index) {
          case 0:
            // Navigate to the Home screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userId:widget.userId)));
            break;
          case 1:
            // Navigate to the Tasks screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => TasksScreen(userId:widget.userId)));
            break;
          case 2:
            // Navigate to the Trees screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => TreesScreen(userId:widget.userId)));
            break;
          // Add more cases for additional screens if needed
        }
      },
      selectedItemColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: widget.currentIndex == 0 ? Colors.black : null,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.home, color: widget.currentIndex == 0 ? Colors.white : null),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: widget.currentIndex == 1 ? Colors.black : null,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment, color: widget.currentIndex == 1 ? Colors.white : null),
          ),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: widget.currentIndex == 2 ? Colors.black : null,
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.tree,
              size: 24,
              color: widget.currentIndex == 2 ? Colors.white : null,
            ),
          ),
          label: 'Trees',
        ),
      ],
    );
  }
}


