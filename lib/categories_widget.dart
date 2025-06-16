// Dans votre fichier categories_widget.dart

// ...
// AJOUTEZ CET IMPORT EN HAUT DU FICHIER
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/screens/all_categories_screen.dart';
import 'package:shop/screens/home/views/components/categories.dart'; // Adaptez le chemin si besoin

// ...

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories(); // Remplace fetchCategories par ta méthode réelle
  }

  // ... (toute votre logique existante reste la même)

  @override
  Widget build(BuildContext context) {
    // ON TRANSFORME LE BUILD POUR AFFICHER UN TITRE ET LA LISTE
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITRE ET BOUTON "Voir tout"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Catégories",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // ACTION DE NAVIGATION
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllCategoriesScreen()),
                  );
                },
                child: const Text("Voir tout"),
              ),
            ],
          ),
        ),

        // VOTRE ANCIENNE LOGIQUE D'AFFICHAGE DE LA LISTE HORIZONTALE
        // Note: j'ai simplifié le FutureBuilder pour l'accueil
        SizedBox(
          height: 120, // La hauteur de votre liste horizontale
          child: FutureBuilder<List<Category>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
                // Sur l'accueil, si ça ne marche pas, on n'affiche rien.
                return const SizedBox.shrink(); 
              }
              // Si on a les données, on affiche la liste
              return _buildCategoriesList(context, snapshot.data!);
            },
          ),
        ),
      ],
    );
  }
  
  Future<List<Category>> fetchCategories() async {
  // Ici, tu récupères les catégories depuis une API, une base de données, etc.
  // Exemple fictif :
  await Future.delayed(const Duration(seconds: 1));
  return [
    Category(id: 1, name: 'Mode', imageUrl: '...'),
    Category(id: 2, name: 'Électronique', imageUrl: '...'),
    // ...
  ];
}

  Widget _buildCategoriesList(BuildContext context, List<Category> categories) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: categories.length,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    separatorBuilder: (context, index) => const SizedBox(width: 12),
    itemBuilder: (context, index) {
      final category = categories[index];
      return GestureDetector(
        onTap: () {
          // Action à effectuer lors du clic sur une catégorie
          // Par exemple : Navigator.push vers la page de détails de la catégorie
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundImage: NetworkImage(category.imageUrl ?? ''),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    },
  );
}

  // ... (le reste de votre fichier _CategoriesWidgetState reste identique)
}