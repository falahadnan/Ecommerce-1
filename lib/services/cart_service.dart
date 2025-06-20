import 'package:flutter/foundation.dart';
// SOLUTION 2 : Nettoyage des imports. On ne garde que ceux qui sont nécessaires.
import 'package:shop/models/cart_model.dart' as cart_model;
import 'package:shop/models/product_model.dart';

// Les imports redondants ou conflictuels ont été supprimés.

class CartService with ChangeNotifier {
  // SOLUTION 1 : On appelle le constructeur de Cart avec un argument positionnel, pas nommé.
  final cart_model.Cart _cart = cart_model.Cart([]);

  // Le getter retourne aussi le type préfixé.
  cart_model.Cart get cart => _cart;

  // Le type de la liste est maintenant 'cart_model.CartItem'.
  List<cart_model.CartItem> get items => _cart.items ?? [];

  double get totalPrice {
    return _cart.items
        .fold(0.0, (total, currentItem) => total + (currentItem.subtotal ?? 0));
  }

  void addItem(Product product, {int quantity = 1}) {
    final index =
        _cart.items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _cart.items[index].quantity += quantity;
    } else {
      // SOLUTION 3 : On simplifie la création du CartItem.
      // On ne passe que ce qui est nécessaire : le produit et la quantité.
      // Le modèle CartItem doit être conçu pour fonctionner ainsi.
      _cart.items.add(cart_model.CartItem(
          product: product,
          quantity: quantity,
          id: '',
          productId: null,
          name: '',
          price: 0,
          image: ''));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _cart.items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    final index =
        _cart.items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cart.items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final index =
        _cart.items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_cart.items[index].quantity > 1) {
        _cart.items[index].quantity--;
      } else {
        removeItem(productId);
      }
      notifyListeners();
    }
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index =
        _cart.items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cart.items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.items.clear();
    notifyListeners();
  }
}
