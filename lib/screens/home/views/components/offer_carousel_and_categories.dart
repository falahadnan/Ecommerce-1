// In OffersCarouselAndCategories.dart
import 'package:flutter/material.dart';
// Ensure this path correctly points to your StatefulWidget named Categories
import 'package:shop/screens/home/views/components/categories.dart';
import '../../../../constants.dart';
import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OffersCarousel(),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Categories",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // Ensure 'Categories' here refers to your StatefulWidget
        const CategoriesWidget(), // <<< This line should work if Categories is a widget
      ],
    );
  }
}