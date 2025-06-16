// lib/services/token_manager.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Define AndroidOptions in one place, or ensure it's consistently defined/imported
AndroidOptions _getSecureStorageAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class TokenManager extends ChangeNotifier {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  final _storage = const FlutterSecureStorage();
  String? _currentToken;

  String? get currentToken => _currentToken;

  // Call this once when your app starts (e.g., in main.dart before runApp)
  Future<void> loadTokenFromStorage() async {
    try {
      _currentToken = await _storage.read(key: 'auth_token', aOptions: _getSecureStorageAndroidOptions());
      if (kDebugMode) {
        print("TokenManager: Token loaded from storage on app start: $_currentToken");
      }
    } catch (e) {
      if (kDebugMode) {
        print("TokenManager: Error loading token from storage: $e");
        _currentToken = null; // Ensure token is null if loading fails
      }
    }
    notifyListeners(); // Important if you use this with Provider for UI updates
  }

  Future<void> setToken(String? token) async {
    _currentToken = token;
    try {
      if (token != null && token.isNotEmpty) {
        await _storage.write(key: 'auth_token', value: token, aOptions: _getSecureStorageAndroidOptions());
        if (kDebugMode) {
          print("TokenManager: Token set to '$_currentToken' AND written to secure storage.");
        }
      } else {
        await _storage.delete(key: 'auth_token', aOptions: _getSecureStorageAndroidOptions());
        if (kDebugMode) {
          print("TokenManager: Token cleared from memory AND deleted from secure storage.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("TokenManager: Error interacting with secure storage: $e");
        // If storage fails, the in-memory token is still set/cleared.
        // You might want more sophisticated error handling here.
      }
    }
    notifyListeners(); // Important if you use this with Provider for UI updates
  }

  Future<void> clearToken() async {
    await setToken(null);
  }
}