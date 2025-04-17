import 'dart:convert';
import 'package:http/http.dart' as http;

class SkaidevApiService {
  static const String _baseUrl = "https://admin.skaidev.com/api";
  final String token;

  SkaidevApiService({required this.token});

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
      };

  Future<List<String>> fetchGalleryUrls() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/gallery-store"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> urls = data['all_urls'];
      return List<String>.from(urls);
    } else {
      throw Exception("Failed to load gallery");
    }
  }

  Future<List<String>> fetchVideoGallery({int page = 1}) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/video-gallery?page=$page"),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> videos = data['videos'];
      return videos.map((e) => e['url'].toString()).toList();
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
