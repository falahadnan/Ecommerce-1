import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsImagesScreen extends StatelessWidget {
  const ProductsImagesScreen({super.key});

  Future<List<dynamic>> fetchProducts() async {
    final url = Uri.parse('https://test666.skaidev.com/api/products');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images des produits')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: product['image'] != null
                    ? Image.network(product['image'],
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.image),
                title: Text(product['name'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
