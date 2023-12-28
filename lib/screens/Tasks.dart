// tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:green_quest/components/BottomNavigation.dart';
import 'package:green_quest/components/Drawer.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/models/TasksList.dart';
import 'package:green_quest/models/User.dart';
import 'package:image_picker/image_picker.dart';

class TasksScreen extends StatefulWidget {
  final int? userId;

  TasksScreen({this.userId});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  

  
  String? username;
  int? points;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchTasks();
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

  Future<void> _fetchTasks() async {
    // Fetch tasks from the database
    List<Task> fetchedTasks = await DbHelper.fetchTasks();
    
    setState(() {
      tasks = fetchedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... (rest of the code remains the same)

      body: SingleChildScrollView(
        child: Column(
          children: tasks.map((task) => TaskAccordion(task: task)).toList(),
        ),
      ),
      bottomNavigationBar: MyAppBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle bottom navigation item taps
        },
      ),
    );
  }
}

class TaskAccordion extends StatefulWidget {
  final Task task;

  const TaskAccordion({required this.task});

  @override
  _TaskAccordionState createState() => _TaskAccordionState();
}

class _TaskAccordionState extends State<TaskAccordion> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
Widget build(BuildContext context) {
  if (widget.task != null) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.task.title ?? 'No Title',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Text(
              widget.task.points?.toString() ?? '0',
              style: TextStyle(fontSize: 12.0, color: Colors.black),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.task.description ?? 'No description',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your submission...',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _pickImage();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      child: Text('Error: Task is null.'),
    );
  }
}

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Use the pickedFile to handle the selected image
      // For example, you can display the image or upload it to a server
      // print(pickedFile.path);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}