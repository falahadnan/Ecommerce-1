import 'api_client.dart';

class MediasGallery {
  static Future<Map<String, dynamic>> galleryImage() async {
    try {
      final response = await ApiClient.get('/gallery-image', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load gallery : $e');
    }
  }

  static Future<Map<String, dynamic>> galleryVideo() async {
    try {
      final response = await ApiClient.get('/gallery-video', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load gallery : $e');
    }
  }
}
