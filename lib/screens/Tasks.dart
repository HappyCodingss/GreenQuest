// tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:green_quest/components/BottomNavigation.dart';
import 'package:green_quest/components/Drawer.dart';
import 'package:green_quest/helpers/DBHelpers.dart';
import 'package:green_quest/models/TasksList.dart';
import 'package:green_quest/models/User.dart';
import 'package:image_picker/image_picker.dart';

class TasksScreen extends StatefulWidget {
  final int userId;

  TasksScreen({required this.userId});

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

Future<void> _fetchTasks() async {
    // print("Fetching tasks for userId: ${widget.userId}");
    List<Task> fetchedTasks = await DbHelper.fetchTasksNotDone();
    // print("Fetched ${fetchedTasks.length} tasks");
    setState(() {
      tasks = fetchedTasks;
    });
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
    return Scaffold( appBar: AppBar(
        title: const Text('Quest'),
      ),
      drawer: AppDrawer(username: username!, points: points!),
      body: SafeArea(
        child: SingleChildScrollView(
          child: tasks.isEmpty
              ? _buildNoTasksContainer()
              : Column(
                  children: tasks.map((task) => TaskAccordion(task: task,  refreshTasks: _fetchTasks, userId: widget.userId, points: points ?? 0)).toList(),
        
                ),
        ),
      ),
      bottomNavigationBar: MyAppBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {},
        userId: widget.userId,
      ),
    );
  }
  Widget _buildNoTasksContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Image.asset(
          "assets/images/noTask.png",
          width: 200, 
          height: 200,
        ),
      ),
    );
  }
  }
  

class TaskAccordion extends StatefulWidget {
  final Task task;
  final Function refreshTasks;
  final int userId;
  int? points;

 TaskAccordion({
    required this.task, 
    required this.refreshTasks, 
    required this.userId, 
    this.points});

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
                style: const TextStyle(color: Colors.black),
              ),
            ),
            Text(
              widget.task.points?.toString() ?? '0' + ' points',
              style: const TextStyle(fontSize: 12.0, color: Colors.black),
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
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter your submission...',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await _pickImage();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  

  Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    try {
      setState(() {
        widget.task.isDone = 1;
        // print("task is completed");
      });

      await DbHelper.updateTaskIsDone(widget.task.taskId!, widget.task.isDone!);
      int taskPoints = widget.task.points ?? 0;
      int newPoints = widget.points! + taskPoints;
      await DbHelper.updateUserPoints(widget.userId, newPoints);
      await widget.refreshTasks();
      _showPointsGrantedDialog(taskPoints, newPoints);
    } catch (e) {
      // print("Error updating task: $e");
    }
  } else {
    // print("No image picked");
  }
}





void _showPointsGrantedDialog(int grantedPoints, int newPoints) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Points Granted"),
        content: Text("Congratulations! You have been granted $grantedPoints points. Your new Points $newPoints"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child:const Text("OK"),
          ),
        ],
      );
    },
  );
}

}
