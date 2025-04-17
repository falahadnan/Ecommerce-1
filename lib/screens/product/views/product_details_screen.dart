// lib/screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:shop/services/api_service.dart';
import 'package:shop/models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final bool isProductAvialable;

  const ProductDetailsScreen({super.key, required this.isProductAvailable});

  @override
  _ProductDetailsSrennState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsSrennState extends State<_ProductDetailsSrennState> {
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
   class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

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
