// lib/screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:shop/services/api_service.dart';
import 'package:shop/models/product_model.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future<List<ProductModel>> products = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedProducts = await ApiService.fetchProducts(); // Appel API ici
      setState(() {
        products = loadedProducts;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text('Erreur: $error'));

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('${product.price} ${product.currency}'),
        );
      },
    );
  }
}
