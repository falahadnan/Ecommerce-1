// api_service.dart
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'https://admin.skaidev.com/api/image-gallery'; // L'URL de l'API

  // Méthode pour récupérer les images
  Future<List<dynamic>> fetchImages() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Si la requête réussit (status 200), on décode la réponse JSON
      return jsonDecode(response.body)['images'];  // On accède à la clé 'images' du JSON
    } else {
      // Si la requête échoue, on lance une exception
      throw Exception('Failed to load images');
    }
  }
}
