import 'package:flutter/material.dart';

class AuthManager with ChangeNotifier {
  String _username = ''; // Default value for username
  bool _isAdmin = false; // Default value for admin flag
  String _token = ''; // Default value for token

  String get username => _username;
  bool get isAdmin => _isAdmin;
  String get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  void login({required String username, required String token, required bool isAdmin}) {
    _username = username;
    _isAdmin = isAdmin;
    _token = token;
    notifyListeners();
  }


  void logout() {
    _username = '';
    _isAdmin = false;
    _token = '';
    notifyListeners();
  }
}

