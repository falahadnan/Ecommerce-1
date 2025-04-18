// lib/screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:shop/services/api_service.dart';
import 'package:shop/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final bool isProductAvailable;

  const ProductDetailsScreen({
    super.key,
    required this.isProductAvailable,
    // Require the service
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<ProductModel> products = [];
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
      // Use the injected service instead of static call
      final loadedProducts = await ApiService.fetchProducts();
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Erreur: $error'));
    }

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
