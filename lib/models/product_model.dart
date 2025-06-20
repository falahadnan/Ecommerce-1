// For demo only
import 'package:shop/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart_model.dart' as model_cart;
// SOLUTION : On ajoute un préfixe 'storage' à cette importation pour éviter le conflit.
import 'package:shop/models/cart_storage.dart' as storage;
import 'package:shop/models/product_model.dart';
import 'package:shop/services/cart_model.dart' as service_cart;
// Cette importation reste normale, donc 'CartService' fera référence à CE fichier.
import 'package:shop/services/cart_service.dart';

// --- J'ai corrigé votre ProductModel pour qu'il ait un id fonctionnel ---
class ProductModel {
  final int id; // Ajout d'un champ id
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.id, // L'id est maintenant une propriété de la classe
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });
}

class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final String devise;
  final int discountType;
  final double? discountAmount;
  final String? brandName;
  final String? brandLogo;
  final String categoruId;
  final List<String> images;
  final String? description;
  final double? rating;
  final int? numOfReviews;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.price,
    required this.devise,
    required this.discountType,
    this.discountAmount,
    this.brandName,
    this.brandLogo,
    required this.categoruId,
    required String url,
    this.description,
    this.rating,
    this.numOfReviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String? finalImageUrl;
    if (json['thumbnail_image'] != null && json['thumbnail_image'].toString().isNotEmpty) {
      finalImageUrl = 'https://test666.skaidev.com/api${json['thumbnail_image']}';
    } else if (json['image'] != null && json['image'].toString().isNotEmpty) {
      finalImageUrl = 'https://test666.skaidev.com/api${json['image']}';
    }

    final double finalPrice = double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0;

    return Product(
      id: json["id"],
      name: json["name"],
      price: finalPrice,
      image: finalImageUrl ?? '',
      devise: json["devise"] ?? '',
      discountType: json["discountType"] ?? 0,
      discountAmount: json["discountAmount"]?.toDouble(),
      brandName: json["brandName"],
      brandLogo: json["brandLogo"],
      categoruId: json["category_id"] ?? '', url: '', images: [],
    );
  }

  get imageUrl => null;
  get categoryName => null;
  get categoryImageUrl => null;
  get categorySlug => null;
}

class AddToCartButton extends StatelessWidget {
  final ProductModel product;

  const AddToCartButton({super.key, required this.product, required bool redirectToCart});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.shopping_cart),
      label: const Text('Ajouter au panier'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: () {
        // PAS D'ERREUR : Le compilateur sait que ce 'CartService' vient de 'services/cart_service.dart'
        final cartService = Provider.of<CartService>(context, listen: false);
        
        cartService.addItem(model_cart.CartItem(
          id: DateTime.now().toString(),
          // J'ai converti l'id en String car il est souvent stocké ainsi.
          productId: product.id.toString(), 
          name: product.title,
          price: product.price,
          image: product.image,
          quantity: 1, 
          // Note : La création d'un 'Product' ici est un peu étrange,
          // mais je la laisse car elle dépend de votre logique métier.
          product: Product(
            id: product.id,
            name: product.title,
            image: product.image,
            price: product.price,
            devise: '',
            discountType: 0,
            categoruId: '', url: '', images: [],
          ),
        ) as Product);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.title} ajouté au panier'),
            action: SnackBarAction(
              label: 'Voir',
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        );
      },
    );
  }
}


List<ProductModel> demoPopularProducts = [];
List<ProductModel> demoFlashSaleProducts = [];
List<ProductModel> demoBestSellersProducts = [];
List<ProductModel> kidsProducts = [];