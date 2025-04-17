import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // URL de l'API de login
  final String _baseUrl = 'https://admin.skaidev.com/api/login';

  // Fonction de login
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Décoder la réponse JSON
      var data = jsonDecode(response.body);
      // Sauvegarder le token dans SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', data['token']);

      return true;
    } else {
      return false;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Déconnexion (en supprimant le token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }
}
