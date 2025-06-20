import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart_item.dart' as cart_item;
import 'package:shop/models/cart_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/services/cart_service.dart';

class AddToCartButton extends StatelessWidget {
  final ProductModel product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.shopping_cart),
      label: const Text('Ajouter au panier'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: () {
        final cartService = Provider.of<CartService>(context, listen: false);
        cartService.addItem(
          cart_item.CartItem(
            id: DateTime.now().toString(),
            productId: product.id?.toString() ?? '',
            name: product.title ?? '',
            price: product.price ?? 0.0,
            image: product.image,
            quantity: 1,
          ) as Product,
        );

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
