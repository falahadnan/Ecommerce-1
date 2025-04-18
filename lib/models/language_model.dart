// lib/models/language_model.dart
class LanguageModel {
  final String language;

  LanguageModel({required this.language});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      language: json['language'] ?? 'Anglais', // Valeur par défaut
    );
  }
}