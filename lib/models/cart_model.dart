// TODO Implement this library.import 'product.dart';

import 'package:shop/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1, required String id, required productId, required String name, required double price, required String image});

  double get total => product.price * quantity;
}
