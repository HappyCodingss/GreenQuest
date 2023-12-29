import 'package:flutter/material.dart';
import 'package:green_quest/components/BottomNavigation.dart';
import 'package:green_quest/components/Drawer.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/models/User.dart';

class TreesScreen extends StatefulWidget {
  final int userId;

  TreesScreen({required this.userId});

  @override
  _TreesScreenState createState() => _TreesScreenState();
}

class _TreesScreenState extends State<TreesScreen> {
  List<Map<String, dynamic>> treeData = [];
  String? username;
  int? userPoints; 

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    DbHelper.initTrees();
    _fetchTrees();
     userPoints = userPoints ?? 0;
  }

  Future<void> _fetchUserDetails() async {
    User? userDetails = await DbHelper.fetchUserById(widget.userId!);
    if (userDetails != null) {
      setState(() {
        username = userDetails.username;
        userPoints = userDetails.points; // Change points to userPoints
      });
    }
  }

  Future<void> _fetchTrees() async {
    List<Map<String, dynamic>> trees = await DbHelper.getTrees();
    if (trees.isNotEmpty) {
      setState(() {
        treeData = trees;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trees'),
      ),
      drawer: AppDrawer(username: username!, points: userPoints!),
      bottomNavigationBar: MyAppBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
        },
        userId: widget.userId,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
        child: ListView.separated(
          itemCount: treeData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          itemBuilder: (context, index) {
      return TreeCard(
          title: treeData[index]['title'],
          imageUrl: treeData[index]['imageUrl'],
          price: treeData[index]['price'],
          userPoints: userPoints!,
          userId: widget.userId,
      );
    },
  ),
),

          ],
        ),
      ),
    );
  }


Future<int?> _fetchUserPoints() async {
  User? userDetails = await DbHelper.fetchUserById(widget.userId!);
  return userDetails?.points;
}
}

class TreeCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final int price;
  int userPoints;
  final int userId;

  TreeCard({required this.title, required this.imageUrl, required this.price, required this.userPoints, required this.userId});

  @override
  _TreeCardState createState() => _TreeCardState();
}

class _TreeCardState extends State<TreeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              height: 150, 
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Price: ${widget.price} points',
                  style:const TextStyle(fontSize: 14, color: Colors.green),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _showPurchaseDialog(context);
                  },
                  child: const Text('Buy'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showPurchaseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                widget.imageUrl,  // Use widget.imageUrl
                height: 100,
                width: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                'Tree: ${widget.title}',  // Use widget.title
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ${widget.price} points',  // Use widget.price
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _handlePurchase(context);

                },
                child: Text('Buy'),
              ),
            ],
          ),
        ),
      );
    },
  );
  }

  void _handlePurchase(BuildContext context) {
  if (widget.userPoints! >= widget.price) {
    widget.userPoints = widget.userPoints! - widget.price;
    DbHelper.updateUserPoints(widget.userId, widget.userPoints!);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Congratulations! You helped our planet by purchasing a tree.'),
        duration: Duration(seconds: 2),
      ),
    );
  } else {
    
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: const Text('You do not have enough points to purchase this tree.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
}