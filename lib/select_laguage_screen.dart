// select_language_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'services/language_service.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  late Future<List<dynamic>> _languagesFuture;

  // Fallback list of languages with flags
  final List<Map<String, dynamic>> _fallbackLanguages = [
    {'id': 'fr', 'name': 'Français', 'flag': '🇫🇷', 'code': 'fr'},
    {'id': 'en', 'name': 'English', 'flag': '🇺🇸', 'code': 'en'},
    {'id': 'es', 'name': 'Español', 'flag': '🇪🇸', 'code': 'es'},
    {'id': 'de', 'name': 'Deutsch', 'flag': '🇩🇪', 'code': 'de'},
    {'id': 'it', 'name': 'Italiano', 'flag': '🇮🇹', 'code': 'it'},
    {'id': 'pt', 'name': 'Português', 'flag': '🇵🇹', 'code': 'pt'},
    {'id': 'ar', 'name': 'العربية', 'flag': '🇸🇦', 'code': 'ar'},
    {'id': 'zh', 'name': '中文', 'flag': '🇨🇳', 'code': 'zh'},
    {'id': 'ja', 'name': '日本語', 'flag': '🇯🇵', 'code': 'ja'},
    {'id': 'ko', 'name': '한국어', 'flag': '🇰🇷', 'code': 'ko'},
    {'id': 'ru', 'name': 'Русский', 'flag': '🇷🇺', 'code': 'ru'},
    {'id': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳', 'code': 'hi'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  void _loadLanguages() {
    _languagesFuture = LanguageService.getStoreLanguages();
  }

  void _retry() {
    setState(() {
      _loadLanguages();
    });
  }

  void _selectLanguage(Map<String, dynamic> language) {
    debugPrint('Langue sélectionnée: ${language['name']} (ID: ${language['id']})');
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Langue sélectionnée: ${language['name']}'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back or to next screen
    // Navigator.pop(context, language);
    // or
    // Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildLanguageItem(Map<String, dynamic> language) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(
            language['flag'] ?? '🌐',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          language['name'] ?? 'Langue inconnue',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Code: ${language['code'] ?? language['id'] ?? 'N/A'}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _selectLanguage(language),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              color: Colors.grey,
              size: 70,
            ),
            const SizedBox(height: 20),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Impossible de récupérer la liste des langues.\nUtilisation de la liste par défaut.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _retry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Force use of fallback languages
                      _languagesFuture = Future.value(_fallbackLanguages);
                    });
                  },
                  child: const Text('Utiliser la liste par défaut'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _processLanguages(List<dynamic> rawLanguages) {
    List<Map<String, dynamic>> processedLanguages = [];
    
    for (var lang in rawLanguages) {
      if (lang is Map) {
        Map<String, dynamic> processedLang = Map<String, dynamic>.from(lang);
        
        // Add flag if not present
        if (!processedLang.containsKey('flag')) {
          String code = (processedLang['code'] ?? processedLang['id'] ?? '').toString().toLowerCase();
          processedLang['flag'] = _getFlagForLanguageCode(code);
        }
        
        processedLanguages.add(processedLang);
      }
    }
    
    return processedLanguages;
  }

  String _getFlagForLanguageCode(String code) {
    const Map<String, String> languageFlags = {
      'fr': '🇫🇷',
      'en': '🇺🇸',
      'es': '🇪🇸',
      'de': '🇩🇪',
      'it': '🇮🇹',
      'pt': '🇵🇹',
      'ar': '🇸🇦',
      'zh': '🇨🇳',
      'ja': '🇯🇵',
      'ko': '🇰🇷',
      'ru': '🇷🇺',
      'hi': '🇮🇳',
      'nl': '🇳🇱',
      'sv': '🇸🇪',
      'da': '🇩🇰',
      'no': '🇳🇴',
      'fi': '🇫🇮',
      'pl': '🇵🇱',
      'tr': '🇹🇷',
      'th': '🇹🇭',
      'vi': '🇻🇳',
    };
    
    return languageFlags[code] ?? '🌐';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir une langue'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _languagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement des langues...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            debugPrint('Erreur FutureBuilder: ${snapshot.error}');
            
            // Use fallback languages when there's an error
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.orange[100],
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Connexion impossible - Utilisation de la liste par défaut',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: _fallbackLanguages.length,
                    itemBuilder: (context, index) {
                      return _buildLanguageItem(_fallbackLanguages[index]);
                    },
                  ),
                ),
              ],
            );
          }

          final rawLanguages = snapshot.data ?? [];
          if (rawLanguages.isEmpty) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.blue[100],
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Aucune langue trouvée - Utilisation de la liste par défaut',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: _fallbackLanguages.length,
                    itemBuilder: (context, index) {
                      return _buildLanguageItem(_fallbackLanguages[index]);
                    },
                  ),
                ),
              ],
            );
          }

          // Process languages to add flags
          final languages = _processLanguages(rawLanguages);

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: languages.length,
            itemBuilder: (context, index) {
              return _buildLanguageItem(languages[index]);
            },
          );
        },
      ),
    );
  }
}