// lib/services/auth_service.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Keep for _getAndroidOptions if defined here
import 'package:shop/token_manager.dart';
import 'api_client.dart';
// Import TokenManager

// Consistent AndroidOptions definition
AndroidOptions _getAuthServiceAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );


class AuthService {
  // No direct _storage instance needed here anymore

  static Future<void> login(String email, String password) async {
    if (kDebugMode) {
      print("AuthService: Attempting login for email: $email");
    }
    try {
      final response = await ApiClient.post(
        '/login', // This will use the ApiClient's hardcoded URL for now
        {'email': email, 'password': password},
      );

      // Safely access response data and token
      if (response.data != null && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> responseData = response.data;
        final String? token = responseData['token'] as String?;

        if (token != null && token.isNotEmpty) {
          await TokenManager().setToken(token); // USE TOKEN MANAGER
          if (kDebugMode) {
            print("AuthService: Login successful, token processed by TokenManager: $token");
          }
        } else {
          if (kDebugMode) {
            print("AuthService: Login successful, but token not found or empty in response data.");
            print("AuthService: Response data from server was: $responseData");
          }
          throw Exception('Login successful, but token was missing in the server response.');
        }
      } else {
        if (kDebugMode) {
          print("AuthService: Login successful, but response data is null or not a map.");
          print("AuthService: Response from server was: ${response.data}");
        }
        throw Exception('Login successful, but server response format was unexpected.');
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print("AuthService: DioError during login: ${e.message}");
        if (e.response != null) {
          print("AuthService: DioError response status: ${e.response?.statusCode}");
          print("AuthService: DioError response data: ${e.response?.data}");
        } else {
          print("AuthService: DioError type: ${e.type}");
        }
      }
      String errorMessage = 'Login failed.';
      if (e.response?.data != null && e.response?.data is Map<String, dynamic>) {
        errorMessage = e.response?.data['message']?.toString() ?? 'Login failed: Server error (no specific message).';
      } else if (e.response?.data != null) {
        errorMessage = 'Login failed: ${e.response?.data.toString()}';
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.sendTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Login failed: Connection timeout. Please check your internet or try again.';
      } else if (e.type == DioExceptionType.unknown && e.error is SocketException) {
         errorMessage = 'Login failed: Network error. Please check your internet connection.';
      } else {
        errorMessage = 'Login failed due to an unexpected error.';
      }
      throw Exception(errorMessage);
    } catch (e) { // Catch any other exceptions (like the ones we throw)
       if (kDebugMode) {
        print("AuthService: General error during login: $e");
      }
      // Avoid re-wrapping "Exception: " if it's already there
      throw Exception(e.toString().startsWith("Exception: ") ? e.toString() : "Login failed: $e");
    }
  }

  // This method can be used for debugging or specific checks,
  // but general token access for APIs should now go through TokenManager().currentToken
  static Future<String?> getStoredTokenDirectlyForDebug() async {
    try {
      return await const FlutterSecureStorage().read(key: 'auth_token', aOptions: _getAuthServiceAndroidOptions());
    } catch (e) {
      if (kDebugMode) print("AuthService: Error reading token directly from storage for debug: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    if (kDebugMode) {
      print("AuthService: Attempting logout.");
    }
    try {
      // This ApiClient.post will use TokenManager().currentToken via ApiClient's modification
      await ApiClient.post('/logout', {});
      if (kDebugMode) {
        print("AuthService: API logout call successful.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("AuthService: Error during API logout call: $e. Continuing with local token clearing.");
      }
      // Decide if an API logout failure should prevent local token clearing. Usually not.
    }
    await TokenManager().clearToken(); // Clear token via manager (from memory and storage)
    if (kDebugMode) {
      print("AuthService: Logged out. Token cleared by TokenManager.");
    }
  }
}