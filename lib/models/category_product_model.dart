// In your Category model definition
import 'package:flutter/foundation.dart';

class Category {
  final int id;
  final String name;
  final String? serverUrl; // The 'url' field from the API (e.g., "category-1")
  final String? slug; // The 'slug' field from the API
  final String? imageUrl; // This will be the full image URL

  Category({
    required this.id,
    required this.name,
    this.serverUrl,
    this.slug,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      // print("Parsing Category from JSON: $json");
    }

    String? finalImageUrl = json['image'];

    // Si l'API peut aussi envoyer 'thumbnail_image', on peut le prioriser :
    if (json['thumbnail_image'] != null &&
        json['thumbnail_image'].toString().isNotEmpty) {
      // Assurez-vous que c'est une URL complète ou reconstruisez-la.
      finalImageUrl = json['thumbnail_image'];
    }

    return Category(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unnamed Category',
      serverUrl: json['url'] as String?, // Get 'url' from API
      slug: json['slug'] as String?, // Get 'slug' from API
      imageUrl:
          json['image'] as String?, // Directly use the 'image' URL from API
      // No need to prepend admin.skaidev.com if it's already full
    );
  }
}

class Product {
  final int id;
  final String name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final String? image; // Assuming stock is a String, adjust as needed

  Product({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double? parsedPrice;
    if (json['price'] != null) {
      // tryParse est la méthode la plus sûre :
      // 1. Elle convertit un String ("19.99") en double.
      // 2. Elle ne plante pas si la valeur est invalide (ex: "gratuit"), elle retourne null.
      parsedPrice = double.tryParse(json['price'].toString());
    }

    // --- AMÉLIORATION : Gestion de l'image avec une solution de secours ---
    String? finalImageUrl;
    if (json['thumbnail_image'] != null &&
        json['thumbnail_image'].toString().isNotEmpty) {
      finalImageUrl =
          'https://test666.skaidev.com/api/${json['thumbnail_image']}';
    }
    // Si 'thumbnail_image' n'existe pas, on essaie avec 'image'.
    else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      finalImageUrl = 'https://test666.skaidev.com/api/${json['image']}';
    }

    return Product(
id: int.parse(json['id']),      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      imageUrl: json['thumbnail_image'] != null
          ? 'https://test666.skaidev.com/api/${json['thumbnail_image']}'
          : null,
    );
  }

  get stock => null;
}
