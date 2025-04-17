import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import '../../../constants.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
                childAspectRatio: 0.66,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ProductCard(
                    image: "",
                    brandName: "",
                    title: "",
                    price: 12,
                    priceAfetDiscount: 12,
                    dicountpercent: 12,
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Properly define ProductCard as a StatelessWidget
class ProductCard extends StatelessWidget {
  final String image;
  final String brandName;
  final String title;
  final double price;
  final double priceAfetDiscount;
  final double dicountpercent;
  final VoidCallback press;

  const ProductCard({
    super.key,
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    required this.priceAfetDiscount,
    required this.dicountpercent,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        // Your product card implementation here
        child: Column(
          children: [
            Image.network(image),
            Text(brandName),
            Text(title),
            Text('\$$price'),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}
