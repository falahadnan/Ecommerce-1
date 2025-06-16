import 'package:shop/models/cart_model.dart';

// TODO Implement this library.
class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'name': name,
        'price': price,
        'image': image,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        productId: json['productId'],
        name: json['name'],
        price: json['price'].toDouble(),
        image: json['image'],
        quantity: json['quantity'],
      );
}

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        items:
            List<CartItem>.from(json['items'].map((x) => CartItem.fromJson(x))),
      );
}
