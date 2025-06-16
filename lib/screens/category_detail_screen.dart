import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;

  const CategoryDetailScreen({
    Key? key,
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(imageUrl),
            const SizedBox(height: 16),
            Text(
              'ID: $id',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Slug: $slug',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
