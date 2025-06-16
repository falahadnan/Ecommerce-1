import 'api_client.dart';

class CategoriesApi {
  static Future<Map<String, dynamic>> fetchAllCategories() async {
    try {
      final response = await ApiClient.get('/fetch-categories', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
