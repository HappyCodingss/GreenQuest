import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_quest/helpers/DBHelpers.dart';

class User {
  int? uid;
  late String username;
  late String password; // Include the required password field
  late int points;
  String? imageUrl;

  User({
    this.uid,
    required this.username,
    required this.password,
    required this.points,
    this.imageUrl,
  });

  // Utility method toMap - convert obj to map
  Map<String, dynamic> toMap() {
    return {
      // DbHelper.colId: uid, 
      DbHelper.colUsername: username,
      DbHelper.colPassword: password,
      DbHelper.colPoints: points,
      DbHelper.colImageUrl: imageUrl,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    // Initialize your User object properties from the map
    uid = map[DbHelper.colId];
    username = map[DbHelper.colUsername];
    password = map[DbHelper.colPassword];
    points = map[DbHelper.colPoints];
    imageUrl = map[DbHelper.colImageUrl];
  }
}

class AuthUtilities {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Example: Register a new user
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user != null
          ? User(
              username: email.split('@')[0], 
              password: password, 
              points: 0,
            )
          : null;

      return user;
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  // Example: Get the current authenticated user
  Future<User?> getCurrentUser() async {
  try {
    User? user = _auth.currentUser != null
        ? User(
            uid: int.parse(_auth.currentUser!.uid),
            username: _auth.currentUser!.email!.split('@')[0],
            password: '',
            points: 0,
          )
        : null;

    return user;
  } catch (e) {
    print('Error getting current user: $e');
    return null;
  }
}


  // Example: Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign-out: $e');
    }
  }
}
