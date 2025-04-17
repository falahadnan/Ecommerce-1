import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product_provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: productProvider.products.length,
      itemBuilder: (context, index) {
        final product = productProvider.products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('${product.price} ${product.currency}'),
          leading: Image.network(product.image),
        );
      },
    );
  }
}
