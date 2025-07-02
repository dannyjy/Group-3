import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _currentUserId; // Dummy user ID

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserId => _currentUserId;

  // Dummy user data for demonstration
  final Map<String, String> _users = {
    'test@example.com': 'password123',
    'user@example.com': '123456',
  };

  Future<String> signUpUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      return 'Please enter all the fields';
    }
    if (_users.containsKey(email)) {
      return 'Email already registered.';
    }
    _users[email] = password;
    _isLoggedIn = true;
    _currentUserId = email; // Using email as a dummy user ID
    notifyListeners();
    return 'success';
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please enter all the fields';
    }
    if (_users.containsKey(email) && _users[email] == password) {
      _isLoggedIn = true;
      _currentUserId = email; // Using email as a dummy user ID
      notifyListeners();
      return 'success';
    } else {
      return 'Invalid email or password.';
    }
  }

  void signOut() {
    _isLoggedIn = false;
    _currentUserId = null;
    notifyListeners();
  }
}
