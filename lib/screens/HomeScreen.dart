import 'package:flutter/material.dart';
import 'package:green_quest/models/BottomNavigation.dart';
import 'package:green_quest/models/Drawer.dart';
import 'package:green_quest/screens/Login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:green_quest/screens/Tasks.dart';
import 'package:green_quest/screens/Trees.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Future<void> _confirmLogout() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildCard(String title, String description, String imageUrl, {bool reverse = false}) {
  return GestureDetector(
    onTap: () {
      // Add navigation logic here
    },
    child: Card(
      elevation: 4,
      child: Row(
        children: [
          if (!reverse)
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
          Container(
            width: 200,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  title,
                  style:const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 Text(
                  description,
                  style:const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (reverse)
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenQuest'),
        foregroundColor: Colors.white,
        backgroundColor:const Color(0xFF9DC08B),
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 8),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  'assets/images/GreenQuestLogo.png',
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add your search logic here
            },
            color: Colors.white,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Welcome to GreenQuest!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
             const SizedBox(height: 15),
             _buildCard(
  'Eco-Friendly Task',
  "Empower your journey to a greener lifestyle! Seamlessly engage in eco-friendly tasks, make a positive impact, and contribute to a sustainable future. Your actions matter—start your green quest today!",
  'https://img.pikbest.com/origin/08/99/65/79tpIkbEsTHiC.png!w700wp',
),
const SizedBox(height: 20),
_buildCard(
  'Points System',
  "Earn valuable points for completing tasks and contribute to a sustainable lifestyle. The Points System rewards your eco-friendly efforts, making every action count.",
  'https://static.vecteezy.com/system/resources/previews/024/044/186/non_2x/money-coins-clipart-transparent-background-free-png.png',
  reverse: true,
),
const SizedBox(height: 20),
_buildCard(
  'Tree Catalog',
  "Explore our Tree Catalog and 'purchase' trees using your earned points. Learn about each tree species and the environmental benefits they bring. Plant a tree, grow a greener future!",
  'https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/25440/tree-open-clipart-07022019-clipart-md.png',
),
            ],
          ),
        ),
      ),
       bottomNavigationBar: MyAppBottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
    },
    ),
    );
  }
}
