import 'api_client.dart';

class SpecificProductService {
  static Future<Map<String, dynamic>> fetchProductCategorie(String slug) async {
    try {
      final response = await ApiClient.get('/fetch-categories-product/$slug', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
