// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Pour utiliser les icônes SVG comme dans votre projet
import 'package:shop/constants.dart'; // Pour utiliser les constantes comme primaryColor et defaultPadding
import 'package:shop/models/product_model.dart';
import 'package:shop/services/product_service.dart'; // Assurez-vous que ce service est correct
import 'package:shop/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  // Pour savoir si une recherche a été lancée
  bool _hasSearched = false; 

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIQUE DE RECHERCHE ---
  Future<void> _performSearch(String query) async {
    // Ne rien faire si la recherche est vide
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true; // On marque qu'une recherche a eu lieu
    });

    try {
      // On utilise le service existant pour récupérer TOUS les produits
      final data = await ProductService.fetchAllProducts();
      final List jsonList = data['products'] ?? [];
      final allProducts = jsonList.map((j) => Product.fromJson(j)).toList();

      // On filtre les produits en local (client-side)
      setState(() {
        _searchResults = allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } catch (e) {
      // Gérer l'erreur avec un message clair
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de réseau: ${e.toString()}")),
      );
    } finally {
      // S'assurer que le chargement s'arrête, même en cas d'erreur
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- CONSTRUCTION DE L'INTERFACE UTILISATEUR ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rechercher un produit"),
        // Vous pouvez adapter le style de l'appBar à votre thème
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // --- CHAMP DE RECHERCHE ---
            _buildSearchField(),
            const SizedBox(height: defaultPadding),

            // --- AFFICHAGE DES RÉSULTATS ---
            Expanded(
              child: _buildResultsView(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour le champ de recherche
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true, // Le clavier s'ouvre automatiquement
      onSubmitted: _performSearch, // Lance la recherche quand on appuie sur "Entrée"
      decoration: InputDecoration(
        hintText: "Que cherchez-vous ?",

        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _performSearch(_searchController.text),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Widget pour afficher les résultats ou les messages
  Widget _buildResultsView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return const Center(
        child: Text(
          "Commencez votre recherche.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          "Aucun produit trouvé.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Affichage des résultats dans une grille
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 produits par ligne
        childAspectRatio: 0.75, // Ratio hauteur/largeur de chaque carte
        mainAxisSpacing: defaultPadding,
        crossAxisSpacing: defaultPadding,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual product detail UI
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image, height: 200),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${product.price} ${product.devise}', style: const TextStyle(fontSize: 18, color: primaryColor)),
            // Add more product details here
          ],
        ),
      ),
    );
  }
}

// --- WIDGET POUR LA CARTE PRODUIT (POUR UNE MEILLEURE ORGANISATION) ---
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Hero(
                  tag: "product_${product.id}", // Pour une animation fluide
                  child: Image.network(
                    product.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '${product.price} ${product.devise}',
                style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}