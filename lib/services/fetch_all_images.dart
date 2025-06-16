import 'api_client.dart';

class FetchAllImages {
  static Future<List<String>> fetchImageUrls() async {
    try {
      final response = await ApiClient.get('/gallery-store', body: {});
      final allUrls = List<String>.from(response.data['all_urls']);

      // Filtrer uniquement les images (extensions .jpg, .jpeg, .png, etc.)
      final imageUrls = allUrls
          .where((url) =>
              url.toLowerCase().endsWith('.jpg') ||
              url.toLowerCase().endsWith('.jpeg') ||
              url.toLowerCase().endsWith('.png'))
          .toList();

      return imageUrls;
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }
}
