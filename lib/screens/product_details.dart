// product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// Importez le modèle Product depuis votre fichier de liste
import 'products_list_screen.dart'; // Assurez-vous que le chemin est correct

class ProductDetailsScreen extends StatefulWidget {
  final int productId; // On reçoit l'ID du produit à afficher

  const ProductDetailsScreen({Key? key, required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Le Future va maintenant retourner un seul Product, pas une liste
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    // On lance la recherche du produit spécifique
    _productFuture = fetchSingleProduct(widget.productId);
  }

  Future<Product> fetchSingleProduct(int id) async {
    try {
      final response =
          await Dio().get('https://test666.skaidev.com/api/fetch-all-products');

      if (response.statusCode == 200) {
        final productsData = response.data['products'];

        // === VOTRE NOUVEAU CODE A ÉTÉ IMPLÉMENTÉ ICI ===
        // Il vérifie maintenant si 'productsData' est une List.
        if (productsData is List) {
          final List<Product> allProducts =
              productsData.map((json) => Product.fromJson(json)).toList();

          // On cherche le produit avec le bon ID dans la liste
          try {
            final product = allProducts.firstWhere((p) => p.id == id);
            return product;
          } catch (e) {
            throw Exception("Produit avec l'ID $id non trouvé.");
          }
        } else {
          // Si les données ne sont PAS une liste, cette erreur sera levée.
          throw Exception('Le format des données "products" est inattendu (attendu: List, reçu: ${productsData.runtimeType}).');
        }

      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de récupérer le produit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Produit'),
      ),
      // Le reste de l'interface utilisateur ne change pas.
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Produit non trouvé.'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.image,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 50);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price} ${product.devise}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "Ceci est une description statique pour le produit '${product.name}'. L'API ne fournissant pas de description, nous en ajoutons une ici pour l'exemple. Vous pouvez remplacer ce texte par les vraies données si elles deviennent disponibles.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}