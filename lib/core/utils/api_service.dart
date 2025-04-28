import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://srv797850.hstgr.cloud/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Register
  static Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      '/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  // Login
  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
  }
}
