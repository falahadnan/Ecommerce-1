// products_list_screen.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop/screens/product_details.dart';
import 'product_details_screen.dart'; // Pour naviguer vers l'écran de détails

// --- MODÈLE DE DONNÉES POUR UN PRODUIT ---
// On le définit ici pour qu'il soit accessible par les deux écrans.
class Product {
  final int id;
  final String name;
  final String price;
  final String devise;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.devise,
    required this.image,
  });

  // Méthode pour créer une instance de Product à partir d'un JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      devise: json['devise'],
      image: json['image'],
    );
  }
}

// --- ÉCRAN D'AFFICHAGE DE LA LISTE DES PRODUITS ---
class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({Key? key}) : super(key: key);

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  // Un Future qui contiendra notre liste de produits
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // On lance la récupération des données au démarrage de l'écran
    _productsFuture = fetchAllProducts();
  }

  // Fonction pour récupérer tous les produits depuis l'API
  Future<List<Product>> fetchAllProducts() async {
    try {
      final response = await Dio().get('https://test666.skaidev.com/api/fetch-all-products');

      if (response.statusCode == 200) {
        // On récupère la liste des produits depuis la clé 'products' du JSON
        final List<dynamic> productsData = response.data['products'];
        
        // On transforme la liste de JSON en une liste d'objets Product
        return productsData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      // On propage l'erreur pour que le FutureBuilder puisse l'afficher
      throw Exception('Impossible de récupérer les produits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // Cas 1: En attente des données
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Cas 2: Une erreur est survenue
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          // Cas 3: Pas de données (ou liste vide)
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun produit trouvé.'));
          }

          // Cas 4: Les données sont arrivées, on les affiche
          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Image.network(
                    product.image,
                    width: 80,
                    fit: BoxFit.cover,
                    // Affiche un indicateur de chargement pour chaque image
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(child: CircularProgressIndicator()));
                    },
                    // Affiche une icône d'erreur si l'image ne charge pas
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 40);
                    },
                  ),
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${product.price} ${product.devise}', style: const TextStyle(color: Colors.blueAccent)),
                  onTap: () {
                    // Action au clic : naviguer vers l'écran de détails
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          productId: product.id, // On passe l'ID du produit cliqué
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}