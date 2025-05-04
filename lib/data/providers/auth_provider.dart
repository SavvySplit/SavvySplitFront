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
  
  // User name
  String? _userName;
  String? get userName => _userName;
  
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

  // Register user with API
  Future<void> registerUser(String name, String email, String password) async {
    setLoading(true);
    try {
      // Store user name
      _userName = name;
      
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        print('User registered successfully: $email');
        setLoading(false);
      } else if (response.statusCode == 302) {
        // 302 typically means redirect, which in registration context often means the user already exists
        setErrorMessage('User with this email already exists. Please use a different email or login.');
      } else {
        // Handle error from API
        String errorMsg = 'Registration failed. Please try again.';
        if (response.data is Map) {
          errorMsg = response.data['message'] ?? errorMsg;
        }
        setErrorMessage(errorMsg);
      }
    } on DioException catch (e) {
      // Handle Dio errors
      String errorMessage = 'Registration failed';
      
      if (e.response != null) {
        // The server responded with an error
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
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
        
        // Store user ID from response if available
        if (response.data is Map && 
            response.data['user'] != null && 
            response.data['user'] is Map && 
            response.data['user']['id'] != null) {
          _userId = response.data['user']['id'].toString();
          
          // Store user name if provided in the response
          if (response.data['user']['name'] != null) {
            _userName = response.data['user']['name'].toString();
          }
        } else {
          // Fallback ID if not provided by API
          _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        }
        
        // Store token if provided
        if (response.data is Map && response.data['token'] != null) {
          // Here you would store the token for future authenticated requests
          // e.g., using secure storage or other state management
          print('Token received: ${response.data['token']}');
        }
        
        setLoading(false);
      } else {
        // Handle error from API
        String errorMsg = 'Login failed. Please try again.';
        if (response.data is Map) {
          errorMsg = response.data['message'] ?? errorMsg;
        }
        setErrorMessage(errorMsg);
      }
    } on DioException catch (e) {
      // Handle Dio errors
      String errorMessage = 'Login failed';
      
      if (e.response != null) {
        // The server responded with an error
        if (e.response?.data is Map) {
          errorMessage = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
        } else {
          errorMessage = 'Server error: ${e.response?.statusCode}';
        }
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
    // Add any other cleanup needed
    notifyListeners();
  }
}
