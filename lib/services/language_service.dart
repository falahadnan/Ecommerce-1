import 'package:flutter/material.dart';
import 'api_service.dart';

class LanguageService {
  final ApiService _apiService;
  String _currentLanguage = 'fr';

  LanguageService(this._apiService);

  // Getter pour la langue actuelle
  String get currentLanguage => _currentLanguage;

  // Récupère la langue du store depuis l'API
  Future<String> getStoreLanguage() async {
    try {
      final language = await ApiService.getStoreLanguage();
      _currentLanguage = language;
      return language;
    } catch (e) {
      debugPrint('Error fetching store language: $e');
      return _currentLanguage; // Retourne la langue par défaut en cas d'erreur
    }
  }

  // Change la langue localement (sans appel API)
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }

  // Vérifie si la langue actuelle est une certaine langue
  bool isLanguage(String languageCode) {
    return _currentLanguage == languageCode;
  }

  // Traductions simples (pour un vrai projet, utilisez plutôt un package comme flutter_localizations)
  String translate(String key) {
    final translations = {
      'fr': {
        'welcome': 'Bienvenue',
        'products': 'Produits',
        'settings': 'Paramètres',
      },
      'en': {
        'welcome': 'Welcome',
        'products': 'Products',
        'settings': 'Settings',
      },
      // Ajoutez d'autres langues au besoin
    };

    return translations[_currentLanguage]?[key] ?? key;
  }
}
