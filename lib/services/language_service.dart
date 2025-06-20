// services/language_service.dart

import 'package:flutter/foundation.dart';
// IMPORTANT : Assurez-vous d'importer votre ApiClient ici.
// Le chemin peut être différent dans votre projet.
import 'api_client.dart'; 

class LanguageService {
  /// Récupère la liste des langues depuis votre API.
  static Future<List<dynamic>> getStoreLanguages() async {
    try {
      // Étape 1 : On appelle votre API via votre ApiClient
      final response = await ApiClient.get('/get-store-language');

      // Étape 2 : On vérifie si l'appel a réussi (code 200)
      // et si la structure des données est correcte (une Map avec une clé 'data' qui contient une List)
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['data'] is List) {
        
        // Étape 3 : Si tout est bon, on retourne la liste des langues.
        // C'est ce que le FutureBuilder recevra dans snapshot.data
        return response.data['data'];

      } else {
        // Si la réponse n'a pas le bon format, on génère une erreur.
        debugPrint('Format de réponse inattendu: ${response.data}');
        throw Exception('Format de réponse du serveur incorrect.');
      }
    } catch (e) {
      // Si une erreur (réseau, etc.) se produit, on la capture.
      debugPrint('Erreur dans LanguageService: $e');
      // On lance une exception claire. C'est ce message qui sera affiché à l'écran.
      throw Exception('Impossible de charger les langues.');
    }
  }
}