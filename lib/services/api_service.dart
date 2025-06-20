// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://test666.skaidev.com/api';
  static const storage = FlutterSecureStorage();

  static get page => null;

  static Future<Map<String, dynamic>> fetchLanguage() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/get-store-language'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> fetchColors() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/fonts-and-colors'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> fetchProducts() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/fetch-all-products'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> fetchGallery() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/gallery-store'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> fetchStorePrompt() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/get-store-prompt'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> fetchCategories(int currentPage) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://test666.skaidev.com/api/fetch-categories?page=$page'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching categories: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchtest34() async {
    throw UnimplementedError('fetchtest34 is not implemented yet.');
  }

  static Future<Map<String, dynamic>> fetchVoituresNeuves() async {
    throw UnimplementedError('fetchVoituresNeuves is not implemented yet.');
  }
}
