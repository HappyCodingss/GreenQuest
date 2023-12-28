import 'package:green_quest/models/TasksList.dart';
import 'package:green_quest/models/User.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

  static const dbName = 'green_quest.db';
  static const dbVersion = 3;
  static const tbName = 'user';
  static const colId = 'id';
  static const colUsername = 'username';
  static const colPassword = 'password';
  static const colPoints = 'points';
  static const colImageUrl = 'imageUrl';

  static const taskTBName = 'task';
  static const colTaskId = 'taskId';
  static const colTaskTitle = 'title';
  static const colTaskDescription = 'description';
  static const colTaskPoints = 'points';
  static const colTaskCompleted = 'completed';

static final List<Task> fixedTasks = [
    Task( description:'Spend 15 minutes picking up litter in a local park or along a trail.',isDone: 0, points:9, title: 'Trash Cleanup',),
    Task(title:'Reduce Water Usage', description:'Take a shorter shower today.',isDone:0, points:6),
    Task(title:'Energy-Saving Day', description:'Turn off lights and electronic devices when not in use for a day.',isDone:0, points:12),
    Task(title:'Reusable Challenge', description:'Use only reusable water bottles and coffee mugs for a week.',isDone:0, points:15),
    Task(title:'Eco-Friendly Transportation', description:'Walk, bike, or use public transportation for a day.',isDone:0, points:18),
    Task(title:'Plant a Seed', description:'Plant a tree sapling or a seed in your garden.',isDone:0, points:21),
    Task(title:'Waste Sorting', description:'Implement a waste sorting system at home.',isDone:0,points: 24),
    Task(title:'Meatless Meal', description:'Have a meatless meal for a day.',isDone:0,points: 27),
    Task(title:'Educate and Share', description:'Share an environmental fact or tip on social media.',isDone:0,points: 30),
    Task(title:'Local Farmers Market', description:'Purchase produce from a local farmers market.',isDone:0,points: 3),
    Task(title:'Turn Off Unnecessary Appliances', description:'Turn off appliances and lights when not in use.',isDone:0,points: 9),
    Task(title:'Use Cloth Bags', description:'Use reusable cloth bags instead of plastic bags.',isDone:0, points:6),
    Task(title:'Go Paperless', description:'Switch to digital documents and reduce paper usage.',isDone:0, points:12),
    Task(title:'Plant Wildflowers', description:'Plant wildflowers to support local pollinators.',isDone:0, points:15),
    Task(title:'Conserve Energy at Home', description:'Turn off lights and unplug devices when not needed.',isDone:0,points:18),
    Task(title:'Recycle Electronics', description:'Recycle old electronic devices properly.',isDone:0, points:21),
    Task(title:'Take Public Transportation', description:'Use public transportation instead of a personal vehicle.',isDone:0,points: 24),
    Task(title:'Reduce Single-Use Plastics', description:'Avoid single-use plastics for a day.',isDone:0, points:27),
    Task(title:'Support Local Eco-Friendly Businesses', description:'Shop from local businesses that prioritize sustainability.',isDone: 0, points:30),
    Task(title:'Join a Community Cleanup', description:'Participate in a community cleanup event.',isDone:0, points:3),
  ];

  static Future<Database> openDB() async {
  var path = join(await getDatabasesPath(), DbHelper.dbName);
  var userTableSql =
      'CREATE TABLE IF NOT EXISTS $tbName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUsername TEXT, $colPassword TEXT, $colPoints INT, $colImageUrl TEXT)';
  
  var taskTableSql =
      'CREATE TABLE IF NOT EXISTS $taskTBName($colTaskId INTEGER PRIMARY KEY AUTOINCREMENT, $colTaskTitle TEXT, $colTaskDescription TEXT, $colTaskPoints INT, $colTaskCompleted INTEGER DEFAULT 0)';
  
  // print(sql);
  var db = await openDatabase(
    path,
    version: DbHelper.dbVersion,
    onCreate: (db, version) {
      db.execute(userTableSql);
      db.execute(taskTableSql);
      print('tables $tbName and $taskTBName created');
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (newVersion <= oldVersion) return;
      db.execute('DROP TABLE IF EXISTS $tbName');
      db.execute('DROP TABLE IF EXISTS $taskTBName');
      db.execute(userTableSql);
      db.execute(taskTableSql);
      print('tables $tbName and $taskTBName dropped and recreated');
    },
  );
  return db;
}

static Future<void> insertFixedTasks(List<Task> tasks) async {
    final db = await openDB();

    for (Task task in tasks) {
      await db.insert(
        taskTBName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    print('Fixed tasks inserted into the database');
  }

  static Future<void> initTasks() async {
    final db = await openDB();

    // Check if tasks already exist in the database
    List<Map<String, dynamic>> existingTasks =
        await db.query(taskTBName, limit: 1);

    if (existingTasks.isEmpty) {
      // Tasks table is empty, insert fixed tasks
      for (Task task in fixedTasks) {
        await insertTask(task);
      }
    }
  }
  
  static Future<void> insertTask(Task task) async {
    final db = await openDB();
    var id = await db.insert(
      taskTBName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    task.taskId = id;
  }
  

static Future<List<Task>> fetchTasks() async {
  final db = await openDB();
  List<Map<String, dynamic>> results = await db.query(taskTBName);

  List<Task> tasks = results.map((map) => Task.fromMap(map)).toList();

  return tasks;
}

  static void insertUser(User u) async {
    final db = await openDB();
    var id = await db.insert(
      tbName,
      u.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('inserted id: $id');
  }

  static Future<bool> isUserExists(String username) async {
    final db = await openDB();
    var result = await db.query(
      tbName,
      where: '$colUsername = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }
  static Future<bool> isPasswordCorrect(String username, String enteredPassword) async {
    final db = await openDB();
    List<Map<String, dynamic>> users = await db.query(
      tbName,
      where: '$colUsername = ?',
      whereArgs: [username],
    );
    if (users.isNotEmpty) {
      String storedPassword = users[0][colPassword];
      return storedPassword == enteredPassword;
    }
    return false;
  }

static Future<User?> fetchUserByUsername(String username) async {
    final db = await openDB();
    List<Map<String, dynamic>> results = await db.query(
      tbName,
      where: '$colUsername = ?',
      whereArgs: [username],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }

    return null;
  }

   Future<User?> getUserDataByUsername(String username) async {
    final db = await openDB();
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
   }
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await openDB();
    return await db.query(tbName);
  }

  static void deleteRaw(int id) async {
    final db = await openDB();
    var num = await db.rawDelete('DELETE FROM $tbName WHERE $colId = $id');
    print('deleted $num rows');
  }


// Functions for shared preferences
Future<void> setLoggedInUser(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('loggedInUser', username);
}

Future<String?> getLoggedInUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('loggedInUser');
}


 static Future<User?> getCurrentUser() async {
    int? activeUserId = await getActiveUserId();

    if (activeUserId != null) {
      return fetchUserById(activeUserId);
    }

    return null;
  }

  static Future<int?> getActiveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('activeUserId');
  } 

  static Future<User?> fetchUserById(int userId) async {
    final db = await openDB();
    List<Map<String, dynamic>> results = await db.query(
      tbName,
      where: '$colId = ?',
      whereArgs: [userId],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }

    return null;
  }
  static Future<User?> fetchUserDetails(String username) async {
  final db = await openDB();
  List<Map<String, dynamic>> results = await db.query(
    tbName,
    where: '$colUsername = ?',
    whereArgs: [username],
  );

  if (results.isNotEmpty) {
    return User.fromMap(results.first);
  }

  return null;
}

}