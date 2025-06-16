import 'api_client.dart';

class FontsService {

  static Future<Map<String, dynamic>> fontsAndColors() async {
    try {
      final response = await ApiClient.get('/fonts-and-colors', body: {});
      return response.data;
    } catch(e) {
      throw Exception('Failed to load Fonts   :   $e');
    }
  }

}