// product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop/models/product_model.dart';
// Importez le modèle Product depuis votre fichier de liste
// import 'products_list_screen.dart'; // Cet import est maintenant correct

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Product received: ${product.toString()}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Produit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image ?? '',
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
              product.name ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${product.price ?? ''} ${product.devise ?? ''}',
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
      ),
    );
  }
}
