import 'package:shop/models/product_model.dart';

class ProductDetailsArguments {
  final Product product;
  final bool isFromAPI;

  ProductDetailsArguments({
    required this.product,
    this.isFromAPI = false,
  });

  @override
  String toString() {
    return 'ProductDetailsArguments{product: $product, isFromAPI: $isFromAPI}';
  }
}