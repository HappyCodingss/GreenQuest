// tasks_screen.dart

import 'package:flutter/material.dart';
import 'package:green_quest/models/BottomNavigation.dart';
import 'package:green_quest/models/Drawer.dart';
import 'package:image_picker/image_picker.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [
    Task('Task 1', 'Description for Task 1'),
    Task('Task 2', 'Description for Task 2'),
    // Add more tasks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Tasks'),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: tasks.map((task) => TaskAccordion(task: task)).toList(),
        ),
      ),
      bottomNavigationBar: MyAppBottomNavigationBar(
    currentIndex: 1,
   onTap: (index) {
    
      }
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
  bool isExpanded = false;
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
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            this.isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(widget.task.title),
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.task.description),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your submission...',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Add image picker logic here
                      await _pickImage();
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            isExpanded: isExpanded,
          ),
        ],
      ),
    );
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

class Task {
  final String title;
  final String description;

  Task(this.title, this.description);
}
