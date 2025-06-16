import 'dart:convert';

import 'api_client.dart';

class ContentGeneration {
  static Future<Map<String, dynamic>> contentGenerator(message) async {
    try {
      var data = json.encode({
        "message": message
      });
      final response = await ApiClient.post('/content-generator', data);
      return response.data;
    } catch(e) {
      throw Exception('Failed to load content_generator :   $e');
    }
  }
}