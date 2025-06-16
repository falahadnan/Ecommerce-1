import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

// Modèle Product minimal
class Product {
  final int id;
  final String name;
  final String image;
  final String price;
  final String devise;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.devise,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        price: json['price'],
        devise: json['devise'],
      );
}

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key, required int productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await Dio().get('https://test666.skaidev.com/api/fetch-all-products');
    if (response.statusCode == 200) {
      final data = response.data;
      var productsRaw = data['products'];
      // Correction ici : si c'est une Map, on prend les valeurs
      if (productsRaw is Map) {
        productsRaw = productsRaw.values.toList();
      }
      final List productsJson = productsRaw as List;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('Aucun produit trouvé.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index]; // index est bien un int ici
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Image.network(p.image,
                      width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(p.name),
                  subtitle: Text('${p.price} ${p.devise}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
