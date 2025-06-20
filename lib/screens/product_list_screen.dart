import 'package:flutter/material.dart';
import 'package:shop/models/product_model.dart';

class ProductListScreen extends StatelessWidget {
  final List<Product> products;
  const ProductListScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des produits')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Image.network(p.image,
                  width: 60, height: 60, fit: BoxFit.cover),
              title: Text(p.name),
              subtitle: Text('${p.price} ${p.devise}'),
              onTap: () {
                // Navigue vers ProductDetailsScreen si besoin
              },
            ),
          );
        },
      ),
    );
  }
}

// Example response data, replace with your actual data source
final Map<String, dynamic> responseData = {
  'products': [
    // Example product data, replace with real data
    {
      'name': 'Product 1',
      'price': 10.0,
      'devise': 'USD',
      'image': 'https://test666.skaidev.com/api/60'
    },
    {
      'name': 'Product 2',
      'price': 20.0,
      'devise': 'USD',
      'image': 'https://test666.skaidev.com/api/60'
    },
  ]
};

final List<Product> products = (responseData['products'] as List)
    .map((json) => Product.fromJson(json))
    .toList();

// To navigate to ProductListScreen, call this inside a function or event handler, for example:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => ProductListScreen(products: products),
//   ),
// );