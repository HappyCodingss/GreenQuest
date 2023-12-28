import 'package:green_quest/helpers/DBHelpers.dart';

class Task {
  int? taskId;
   String? title;
   String? description;  
  int? isDone;
  int? points;


  Task({this.title, 
       this.description,
       this.isDone, 
       this.points,
       });
  
  Map<String, dynamic> toMap() {
    return {
      DbHelper.colTaskId: taskId,
      DbHelper.colTaskTitle: title,
      DbHelper.colTaskPoints: points,
      DbHelper.colTaskDescription: description,
      DbHelper.colTaskCompleted: isDone,
    };
  }

  Task.fromMap(Map<String, dynamic> map) {
    // Initialize your User object properties from the map
    taskId = map[DbHelper.colTaskId];
    title = map[DbHelper.colTaskTitle];
    points = map[DbHelper.colTaskPoints];
    description = map[DbHelper.colTaskDescription];
    isDone = map[DbHelper.colTaskCompleted];
  }
}