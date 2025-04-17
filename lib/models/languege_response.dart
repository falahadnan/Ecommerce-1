// lib/models/language_response.dart
class LanguageResponse {
  final String language;

  LanguageResponse({required this.language});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      language: json['language'],
    );
  }
}