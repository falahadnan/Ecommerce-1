import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop/models/product.dart';

class ProductsApiPage extends StatefulWidget {
  const ProductsApiPage({super.key});

  @override
  State<ProductsApiPage> createState() => _ProductsApiPageState();
}

class _ProductsApiPageState extends State<ProductsApiPage> {
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<dynamic>> fetchProducts() async {
    final response = await Dio().get('https://test666.skaidev.com/api/fetch-all-products');
    if (response.statusCode == 200 && response.data is Map && response.data['products'] != null) {
      var productsRaw = response.data['products'];
      if (productsRaw is Map) {
        productsRaw = productsRaw.values.toList();
      }
      return productsRaw as List;
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des produits')),
      body: FutureBuilder<List<dynamic>>(
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
              final p = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: p['image'] != null
                      ? Image.network(p['image'], width: 60, height: 60, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(p['name'] ?? 'Sans nom'),
                  subtitle: Text('${p['price'] ?? ''} ${p['devise'] ?? ''}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Portefeuille'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur votre portefeuille !',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
