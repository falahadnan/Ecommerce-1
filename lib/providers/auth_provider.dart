import 'package:flutter/foundation.dart';
import 'package:shop/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    try {
      _isAuthenticated = await ApiService.login(email, password);
      if (_isAuthenticated) {
        _token = ApiService.getToken(); 
      }
      notifyListeners();
      return _isAuthenticated;
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }
}