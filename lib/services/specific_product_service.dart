import 'api_client.dart';

class SpecificProductService {
  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(String slug) async {
    try {
      final response = await ApiClient.get('/fetch-categories-product/$slug', body: {});
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Erreur lors du chargement des produits : $e');
    }
  }
}
