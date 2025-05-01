import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:savvysplit/core/utils/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // User information
  String? _userId;
  String? get userId => _userId;
  
  String? _userName;
  String? get userName => _userName;
  
  String? _userEmail;
  String? get userEmail => _userEmail;
  
  // Get first name of user (for display purposes)
  String get firstName {
    if (_userName == null || _userName!.isEmpty) return 'User';
    return _userName!.split(' ').first;
  }
  
  // Get first letter of first name (for avatar)
  String get firstInitial {
    if (_userName == null || _userName!.isEmpty) return 'U';
    return _userName!.split(' ').first[0].toUpperCase();
  }

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

  // Register user with API
  Future<void> registerUser(String name, String email, String password) async {
    setLoading(true);
    try {
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        print('User registered successfully: $email');
        setLoading(false);
      } else {
        // Handle error from API
        final errorMsg = response.data['message'] ?? 'Registration failed. Please try again.';
        setErrorMessage(errorMsg);
      }
    } on DioException catch (e) {
      // Handle Dio errors
      String errorMessage = 'Registration failed';
      
      if (e.response != null) {
        // The server responded with an error
        errorMessage = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server is taking too long to respond. Please try again.';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }
      
      setErrorMessage(errorMessage);
    } catch (e) {
      // Handle other errors
      setErrorMessage('An unexpected error occurred: $e');
    }
  }

  // Login user with API
  Future<void> loginUser(String email, String password) async {
    setLoading(true);
    try {
      final response = await ApiService.login(
        email: email,
        password: password,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Login successful
        print('User logged in successfully: $email');
        
        // Store user ID and name from response if available
        if (response.data['user'] != null) {
          if (response.data['user']['id'] != null) {
            _userId = response.data['user']['id'].toString();
          } else {
            // Fallback ID if not provided by API
            _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
          }
          
          // Store user name
          if (response.data['user']['name'] != null) {
            _userName = response.data['user']['name'];
          }
          
          // Store user email
          if (response.data['user']['email'] != null) {
            _userEmail = response.data['user']['email'];
          } else {
            // Use the email provided during login as fallback
            _userEmail = email;
          }
        }
        
        // Store token if provided
        if (response.data['token'] != null) {
          // Here you would store the token for future authenticated requests
          // e.g., using secure storage or other state management
          print('Token received: ${response.data['token']}');
        }
        
        setLoading(false);
      } else {
        // Handle error from API
        final errorMsg = response.data['message'] ?? 'Login failed. Please try again.';
        setErrorMessage(errorMsg);
      }
    } on DioException catch (e) {
      // Handle Dio errors
      String errorMessage = 'Login failed';
      
      if (e.response != null) {
        // The server responded with an error
        errorMessage = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server is taking too long to respond. Please try again.';
      } else {
        errorMessage = 'Network error: ${e.message}';
      }
      
      setErrorMessage(errorMessage);
    } catch (e) {
      // Handle other errors
      setErrorMessage('An unexpected error occurred: $e');
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
    _userName = null;
    _userEmail = null;
    // Add any other cleanup needed
    notifyListeners();
  }
}
