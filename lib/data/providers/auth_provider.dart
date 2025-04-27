import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // User information
  String? _userId;
  String? get userId => _userId;
  
  // You can expand this with more user properties as needed
  // User? _currentUser;
  // User? get currentUser => _currentUser;

  void setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null; // Clear any previous error when loading starts
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  // Methods for authentication actions will go here:
  // - registerUser
  // - loginUser
  // - forgotPassword
  // - logoutUser

  // Example register method (will be implemented later with API call)
  Future<void> registerUser(String name, String email, String password) async {
    setLoading(true);
    // Simulate registration
    await Future.delayed(const Duration(seconds: 2));
    if (email.contains('error')) {
      setErrorMessage('Registration failed. Please try again.');
    } else {
      // Simulate success
      print('User registered: $email');
      // TODO: Handle successful registration (e.g., navigate, store user info)
      setLoading(false);
    }
  }

  // Example login method (will be implemented later with API call)
  Future<void> loginUser(String email, String password) async {
    setLoading(true);
    // Simulate login
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@error.com') {
      setErrorMessage('Login failed. Invalid credentials.');
    } else {
      // Simulate success
      print('User logged in: $email');
      // Set a simulated user ID
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      // TODO: Handle successful login (e.g., navigate, store user session)
      setLoading(false);
    }
  }

  // Example forgotPassword method (will be implemented later with API call)
  Future<void> forgotPassword(String email) async {
    setLoading(true);
    // Simulate forgot password request
    await Future.delayed(const Duration(seconds: 2));
    if (!email.contains('@')) {
      setErrorMessage('Please enter a valid email address.');
    } else {
      // Simulate success
      print('Password reset email sent to: $email');
      // TODO: Handle successful request
      setLoading(false);
    }
  }

  // Logout method
  void logout() {
    _userId = null;
    // Add any other cleanup needed
    notifyListeners();
  }
}
