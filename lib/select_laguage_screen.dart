import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop/screens/language/views/select_language_screen.dart';
import 'package:dio/dio.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  Future<List<dynamic>> fetchLanguages() async {
    final response = await Dio().get('https://tonapi.com/api/langues');
    if (response.statusCode == 200 && response.data is Map && response.data['data'] != null) {
      final List langues = response.data['data'];
      return langues;
    } else {
      throw Exception('Erreur API : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir une langue')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchLanguages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final languages = snapshot.data ?? [];
          if (languages.isEmpty) {
            return const Center(child: Text('Aucune langue trouvée'));
          }
          return ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final lang = languages[index];
              return ListTile(
                title: Text(lang['name'] ?? ''),
                onTap: () {
                  // Ajoute ici la logique pour changer la langue si besoin
                  Navigator.pushNamed(context, 'select_language');
                },
              );
            },
          );
        },
      ),
    );
  }
}

