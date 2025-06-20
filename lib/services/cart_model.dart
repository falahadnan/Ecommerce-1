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

  // === LA CORRECTION EST ICI ===
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // On s'assure que les valeurs ne sont pas nulles et on les convertit au bon type
    return CartItem(
      // On convertit la valeur en String pour correspondre au type `final String id;`
      id: json['id'].toString(),
      // On fait de même pour productId par sécurité
      productId: json['productId'].toString(), 
      name: json['name'] ?? 'Inconnu',
      // toDouble() est correct car `price` est un double
      price: (json['price'] ?? 0.0).toDouble(), 
      image: json['image'] ?? '',
      // On s'assure que la quantité est bien un int
      quantity: (json['quantity'] ?? 1) as int,
    );
  }

  num? get subtotal => null;
}

// La classe Cart n'a pas besoin de modification
class Cart {
  // ... (le reste du code est correct)
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