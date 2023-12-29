class Task {
  int? taskId;
  String? title;
  String? description;
  int? points;
  int? isDone;

  Task({this.taskId, this.title, this.description, this.points,this.isDone,});

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'points': points,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      title: map['title'],
      description: map['description'],
      points: map['points'],
      isDone: map['isDone'],
    );
  }
}
