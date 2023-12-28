import 'package:flutter/material.dart';
import 'package:green_quest/models/User.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void>userLogin(String username, String password) async {
  
    _user = User(
      uid: null, 
      username: username,
      password: password, 
      points: 0, 
      imageUrl: null, 
    );

    notifyListeners();
  }

  Future<void>userLogout() async {
    _user = null;
    notifyListeners();
  }
}
