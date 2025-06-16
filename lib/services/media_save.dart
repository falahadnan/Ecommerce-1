import 'package:dio/dio.dart';

import 'api_client.dart';

class MediasSave {
  static Future<Map<String, dynamic>> saveImage(path) async {
    try {
      var data = FormData.fromMap({
        'files': [await MultipartFile.fromFile(path, filename: 'file')]
      });
      final response = await ApiClient.post('/save-image', data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load save-image : $e');
    }
  }

  static Future<Map<String, dynamic>> saveVideo(path) async {
    try {
      var data = FormData.fromMap({
        'files': [await MultipartFile.fromFile(path, filename: 'file')]
      });
      final response = await ApiClient.post('/save-video', data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load save-video: $e');
    }
  }
}
