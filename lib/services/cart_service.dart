import 'package:flutter/foundation.dart';
import 'package:shop/models/cart_model.dart' as models;
import 'package:shop/services/cart_model.dart';

import 'cart_model.dart';

class CartService with ChangeNotifier {
  Cart _cart = Cart(items: []);

  Cart get cart => _cart;

  void addItem(models.CartItem item) {
    final index = _cart.items.indexWhere((i) => i.productId == item.product);
    if (index >= 0) {
      _cart.items[index].quantity += item.quantity;
    } else {
      _cart.items.add(item as CartItem);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cart.items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart = Cart(items: []);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _cart.items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      _cart.items[index].quantity = quantity;
      notifyListeners();
    }
  }
}