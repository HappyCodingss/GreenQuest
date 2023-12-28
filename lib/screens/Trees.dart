import 'package:flutter/material.dart';
import 'package:green_quest/components/BottomNavigation.dart';
import 'package:green_quest/components/Drawer.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/models/User.dart';

class TreesScreen extends StatefulWidget {
  final int? userId;

  TreesScreen({this.userId});
  @override
  _TreesScreenState createState() => _TreesScreenState();
}

class _TreesScreenState extends State<TreesScreen> {
  String? username;
  int? points;
  List<Map<String, dynamic>> treeData = [
    {'title': 'Tree 1', 'imageUrl': 'https://placekitten.com/200/200', 'price': 50},
    {'title': 'Tree 2', 'imageUrl': 'https://placekitten.com/201/201', 'price': 75},
    {'title': 'Tree 3', 'imageUrl': 'https://placekitten.com/202/202', 'price': 100},
  ];
@override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }
  Future<void> _fetchUserDetails() async {
    User? userDetails = await DbHelper.fetchUserById(widget.userId!);
    if (userDetails != null) {
      setState(() {
        username = userDetails.username;
        points = userDetails.points;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trees'),
      ),
      drawer: AppDrawer(username: username!, points: points!),
      bottomNavigationBar: MyAppBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle bottom navigation taps if needed
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: treeData.length,
          itemBuilder: (context, index) {
            return TreeCard(
              title: treeData[index]['title'],
              imageUrl: treeData[index]['imageUrl'],
              price: treeData[index]['price'],
            );
          },
        ),
      ),
    );
  }
}

class TreeCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final int price;

  TreeCard({required this.title, required this.imageUrl, required this.price});

  @override
  _TreeCardState createState() => _TreeCardState();
}

class _TreeCardState extends State<TreeCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showPurchaseDialog(context);
          },
          onHover: (hover) {
            _handleHover(hover);
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  height: 150, // Set the desired height for the image
                  width: double.infinity,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: isHovered ? 60 : 0, // Adjust the desired height
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6), // Adjust the opacity as needed
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Price: ${widget.price} points',
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _showPurchaseDialog(context);
                      },
                      child: Text('Buy'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }

  void _showPurchaseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                widget.imageUrl,
                height: 100,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                'Tree: ${widget.title}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ${widget.price} points',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
