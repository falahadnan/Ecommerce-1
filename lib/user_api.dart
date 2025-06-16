import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/services/api_client.dart';


class UserService {
  static Future<Map<String, dynamic>> fetchUser() async {
    try {
      final response = await ApiClient.get('/user', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load user   :   $e');
    }
  }

  /**
   * 
   */
}
