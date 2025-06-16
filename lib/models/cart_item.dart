import 'package:flutter/foundation.dart';
import 'package:shop/models/cart_item.dart' as cart_item;

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String? image;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.image,
    required this.quantity,
  });
}

void addCartItem(product, cartService) {
  cartService.addItem(
    cart_item.CartItem(
      id: DateTime.now().toString(),
      productId: product.id?.toString() ?? '',
      name: product.title ?? '',
      price: product.price ?? 0.0,
      quantity: 1,
    ),
  );
}
