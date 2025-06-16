import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<Map<String, dynamic>>> _bookmarksData;

  @override
  void initState() {
    super.initState();
    _bookmarksData = _fetchBookmarks();
  }

  Future<List<Map<String, dynamic>>> _fetchBookmarks() async {
    // Exemple de données - remplacez par votre appel API réel
    return [
      {
        'id': 101,
        'name': 'Produit favori 1',
        'image': 'https://example.com/product1.jpg',
        'price': 99.99,
        'devise': '€',
      },
      // Ajoutez d'autres favoris...
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: FutureBuilder(
        future: _bookmarksData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final bookmarks = snapshot.data ?? [];
          if (bookmarks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun favoris enregistré'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              return BookmarkItem(item: item);
            },
          );
        },
      ),
    );
  }
}

class BookmarkItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const BookmarkItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: ListTile(
        contentPadding: const EdgeInsets.all(defaultPadding / 2),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: item['image'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey.shade200),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(item['name']),
        subtitle: Text('${item['price']} ${item['devise']}'),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.red),
          onPressed: () {
            // Action pour retirer des favoris
          },
        ),
      ),
    );
  }
}