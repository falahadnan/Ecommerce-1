import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/home/views/components/categories.dart' as my_categories;
import 'package:shop/screens/home/views/components/categories.dart';

// IMPORTANT: Assurez-vous que ces chemins d'importation sont corrects pour votre projet
import 'package:shop/services/categories_service.dart';
import 'package:shop/widgets/home/components/categories_widget.dart'; // Pour réutiliser Category, CategoryButton et ProductsByCategoryScreen
import 'package:shop/constants.dart'; // Pour defaultPadding, etc.


class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  // La logique de récupération des données est la même que dans votre CategoriesWidget
  late Future<List<my_categories.Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategoriesAndHandleRetries();
  }
  
  // Cette méthode appelle le service pour récupérer les catégories
  Future<List<my_categories.Category>> _fetchCategoriesFromApiService() async {
    final Map<String, dynamic> responseData = await CategoriesService.fetchCategoriesFromApi(page: 1);
    final List<dynamic> categoryListFromApi = responseData['entities'] ?? [];
    
    // On convertit la liste de JSON en une liste d'objets Category
    return categoryListFromApi
        .map((jsonItem) => my_categories.Category.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }

  // Cette méthode gère les tentatives de reconnexion en cas d'erreur
  Future<List<my_categories.Category>> _fetchCategoriesAndHandleRetries({int retries = 1}) async {
    for (var i = 0; i < retries; i++) {
      try {
        return await _fetchCategoriesFromApiService();
      } catch (e) {
        if (kDebugMode) print("AllCategoriesScreen: Tentative ${i + 1} échouée. Erreur: $e");
        if (i == retries - 1) rethrow; // Si c'est la dernière tentative, on propage l'erreur
        
        // On ne réessaye que pour les erreurs réseau
        if (e is DioError) {
          await Future.delayed(const Duration(seconds: 2));
        } else {
          rethrow; // Pour les autres erreurs, on arrête
        }
      }
    }
    // Cette ligne ne devrait jamais être atteinte
    throw Exception('Échec du chargement des catégories après $retries tentatives.');
  }

  // Méthode pour rafraîchir la liste
  Future<void> _refreshCategories() async {
    setState(() {
      _categoriesFuture = _fetchCategoriesAndHandleRetries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les catégories'),
      ),
      // On ajoute un RefreshIndicator pour pouvoir "tirer pour rafraîchir"
      body: RefreshIndicator(
        onRefresh: _refreshCategories,
        child: FutureBuilder<List<my_categories.Category>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            // État de chargement
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // État d'erreur
            if (snapshot.hasError) {
              // On réutilise le même widget d'erreur que vous avez déjà créé
              return _buildErrorWidget(context, snapshot.error.toString());
            }

            final categories = snapshot.data;
            // État où la liste est vide
            if (categories == null || categories.isEmpty) {
              return _buildEmptyWidget(context);
            }

            // Si tout va bien, on affiche la grille
            return _buildCategoriesGrid(context, categories);
          },
        ),
      ),
    );
  }

  /// NOUVEAU WIDGET pour afficher les catégories dans une grille
  Widget _buildCategoriesGrid(BuildContext context, List<my_categories.Category> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: categories.length,
      // Configuration de la grille
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,          // 3 colonnes
        crossAxisSpacing: defaultPadding, // Espace horizontal
        mainAxisSpacing: defaultPadding,  // Espace vertical
        childAspectRatio: 0.8,            // Ratio largeur/hauteur pour chaque élément
      ),
      itemBuilder: (context, index) {
        // ON RÉUTILISE VOTRE CategoryButton !
        return CategoryButton(
          category: categories[index],
        );
      },
    );
  }

  // --- Widgets d'aide (copiés depuis votre CategoriesWidget pour être cohérent) ---

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Erreur de chargement', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              error.contains('host lookup') ? 'Serveur indisponible.' : error.replaceFirst("Exception: ", ""),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshCategories,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          const Text('Aucune catégorie disponible', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}