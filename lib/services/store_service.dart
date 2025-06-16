import 'api_client.dart';

class StoreService {
  static Future<Map<String, dynamic>> galleryStore() async {
    try {
      final response = await ApiClient.get('/gallery-store', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load gallery : $e');
    }
  }

  static Future<Map<String, dynamic>> getStorePrompt() async {
    try {
      final response = await ApiClient.get('/get-store-prompt', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load gallery : $e');
    }
  }

  static Future<Map<String, dynamic>> getStoreLanguage() async {
    try {
      final response = await ApiClient.get('/get-store-language', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load gallery : $e');
    }
  }
}
