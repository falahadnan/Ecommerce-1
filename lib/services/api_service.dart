// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/models/product_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:io';

class ApiService {
  static const String _baseUrl = "https://admin.skaidev.com/api";
  static String? _token;

  // Méthode pour récupérer le token
  static String? get token => _token;

  // Authentification
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _token = jsonDecode(response.body)['token'];
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    _token = null;
  }

  // Produits
  static Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/fetch-all-products'),
      headers: _buildHeaders(),
    );

    return _handleResponse<List<ProductModel>>(
      response,
      (data) => (data['products'] as List)
          .map((json) => ProductModel.fromJson(json))
          .toList(),
    );
  }

  // Génération de contenu
  static Future<String> generateContent(String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/content-generator'),
      headers: _buildHeaders(),
      body: jsonEncode({'message': message}),
    );

    return _handleResponse<String>(
      response,
      (data) => data['response']['titles'].join('\n'),
    );
  }

  // Médias
  static Future<List<String>> getGallery() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/gallery-store'),
      headers: _buildHeaders(),
    );

    return _handleResponse<List<String>>(
      response,
      (data) => List<String>.from(data['all_urls']),
    );
  }

  // Téléversement d'images
  static Future<String> uploadImage(File imageFile) async {
    final mimeType = mime(imageFile.path) ?? 'application/octet-stream';
    final mimeData = mimeType.split('/');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/save-image'),
    )
      ..headers.addAll(_buildHeaders())
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeData[0], mimeData[1]),
      ));

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    return _handleResponse<String>(
      responseData,
      (data) => data['file_link'],
    );
  }

  // Téléversement de vidéos
  static Future<String> uploadVideo(File videoFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/save-video'),
    )
      ..headers.addAll(_buildHeaders())
      ..files.add(await http.MultipartFile.fromPath('file', videoFile.path));

    final response = await request.send();
    final responseData = await http.Response.fromStream(response);

    return _handleResponse<String>(
      responseData,
      (data) => data['file_link'],
    );
  }

  // Helpers
  static Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  static T _handleResponse<T>(
    http.Response response,
    T Function(dynamic) parser,
  ) {
    if (response.statusCode == 200) {
      return parser(jsonDecode(response.body));
    } else {
      throw HttpException(
        'Request failed with status: ${response.statusCode}',
        uri: response.request?.url,
      );
    }
  }

  // Autres endpoints
  static Future<String> getStorePrompt() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get-store-prompt'),
      headers: _buildHeaders(),
    );

    return _handleResponse<String>(
      response,
      (data) => data['prompt'],
    );
  }

  static Future<String> getStoreLanguage() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get-store-language'),
      headers: _buildHeaders(),
    );

    return _handleResponse<String>(
      response,
      (data) => data['language'],
    );
  }

  static Future<Map<String, dynamic>> getFontsAndColors() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/fonts-and-colors'),
      headers: _buildHeaders(),
    );

    return _handleResponse<Map<String, dynamic>>(
      response,
      (data) => Map<String, dynamic>.from(data['data']),
    );
  }

  static String? getToken() {}
}