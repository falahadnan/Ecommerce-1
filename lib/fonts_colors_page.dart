import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FontsAndColorsPage extends StatefulWidget {
  const FontsAndColorsPage({super.key});

  @override
  State<FontsAndColorsPage> createState() => _FontsAndColorsPageState();
}

class _FontsAndColorsPageState extends State<FontsAndColorsPage> {
  Map<String, dynamic>? fontsColors; // Pour stocker les couleurs
  bool isLoading = true; // Afficher le loader pendant que l'API se charge

  // Fonction pour récupérer les couleurs
  Future<void> fetchFontsAndColors() async {
    final url = Uri.parse('https://admin.skaidev.com/api/fonts-and-colors');

    try {
      final response = await http.get(url); // On fait la requête GET
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body); // On décode la réponse JSON
        setState(() {
          fontsColors = json; // On stocke les couleurs dans fontsColors
          isLoading = false; // On cache le loader
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFontsAndColors(); // On appelle la fonction pour récupérer les données
  }

  @override
  Widget build(BuildContext context) {
    // Si fontsColors est null, on va afficher un message d'erreur.
    if (fontsColors == null) {
      return const Center(child: CircularProgressIndicator()); // Afficher un loader tant que les couleurs ne sont pas chargées.
    }

    // Récupération des couleurs du JSON
    final primaryColor = fontsColors?['primary_color'] ?? '#FFC700';
    final secondaryColor = fontsColors?['secondary_color'] ?? '#F4F4F3';
    final backgroundColor = fontsColors?['background_color'] ?? '#FFFFFF';

    // Conversion des couleurs hexadécimales en couleurs Flutter
    Color primaryColorFlutter = Color(int.parse('0xFF${primaryColor.substring(1)}'));
    Color secondaryColorFlutter = Color(int.parse('0xFF${secondaryColor.substring(1)}'));
    Color backgroundColorFlutter = Color(int.parse('0xFF${backgroundColor.substring(1)}'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fonts & Colors'),
        backgroundColor: primaryColorFlutter, // Application de la couleur principale dans la barre d'application
      ),
      body: Container(
        color: backgroundColorFlutter, // Application de la couleur de fond
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Un Text avec la couleur secondaire
            Text(
              'Primary Color Applied!',
              style: TextStyle(
                color: primaryColorFlutter, // Application de la couleur primaire au texte
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Un Text avec la couleur secondaire
            Text(
              'Secondary Color Applied!',
              style: TextStyle(
                color: secondaryColorFlutter, // Application de la couleur secondaire au texte
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
        ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/gallery',
      arguments: {'token': '11|nv4dxvDlX2rkrrc9veXq7lDVuIBe19OMAy0dnNSg'},
    );
  },
  child: Text("Ouvrir Galerie"),
)
,
          ],
        ),
      ),
    );
  }
}
