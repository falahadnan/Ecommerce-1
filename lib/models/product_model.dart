class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final String currency;
  final String url;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.currency,
    required this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
      currency: json['devise'],
      url: json['url'],
    );
  }
}