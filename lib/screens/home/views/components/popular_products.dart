// TODO Implement this library. import 'package:dio/dio.dart'; // Not directly used here, but services might use it
import 'package:dio/dio.dart'; // You have this duplicate, remove one
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:shop/components/product/product_card.dart' as product_card;
import 'package:shop/models/product_model.dart'; // Assuming this is your Product model
import 'package:shop/route/screen_export.dart'; // Ensure all screen routes like productDetailsScreenRoute are here
// import 'package:shop/services/content_generation.dart'; // Was a duplicate import
import 'package:shop/services/font_service.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/services/fetch_all_images.dart';
// import 'package:shop/services/store_service.dart'; // Unused in this snippet

import '../../../../constants.dart'; // Ensure defaultPadding, primaryColor etc. are defined here
import '../../../../models/product_details_arguments.dart'; // Ensure this is correctly defined

class PopularProducts extends StatefulWidget {
  @override
  State<PopularProducts> createState() => _PopularProductsState();
  const PopularProducts({super.key});
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<Map<String, dynamic>> _productsFuture;
  late Future<Map<String, dynamic>>
      _colorsFontsFuture; // Renamed for clarity and consistency
  late Future<List<String>> _imagesFuture;
  // int currentPage = 1; // Currently unused in the provided build logic

  @override
  void initState() {
    super.initState();
    print("--- PopularProducts initState ---");
    // Initialize futures directly. Errors within these futures will be caught by their respective FutureBuilders (if used)
    // or by the FutureBuilder for _productsFuture if that's the only one rendered.
    _productsFuture = ProductService.fetchAllProducts();
    _imagesFuture = FetchAllImages
        .fetchImageUrls(); // This will also make an API call using ApiClient
    _colorsFontsFuture = FontsService
        .fontsAndColors(); // This will also make an API call using ApiClient
    print("--- PopularProducts initState completed (futures assigned) ---");
  }

  @override
  Widget build(BuildContext context) {
    print("--- Building PopularProducts widget ---");
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: defaultPadding / 2),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "Popular products",
              style: Theme.of(context).textTheme.titleSmall ??
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              print(
                  "--- PopularProducts FutureBuilder builder --- ConnectionState: ${snapshot.connectionState}");

              if (snapshot.hasError) {
                print("PopularProducts FutureBuilder Error: ${snapshot.error}");
                String errorMessage = snapshot.error.toString();
                if (snapshot.error is DioError) {
                  DioError dioError = snapshot.error as DioError;
                  // Try to get message from DioError response, fallback to DioError message, then generic
                  errorMessage =
                      dioError.response?.data?['message']?.toString() ??
                          dioError.message ??
                          "Failed to load products";
                }
                return Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Text(
                      "Error: ${errorMessage.replaceFirst("Exception: ", "")}"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                print("PopularProducts FutureBuilder: Waiting for products...");
                return const ProductsSkelton(); // Ensure ProductsSkelton is defined and imported
              }

              if (!snapshot.hasData || snapshot.data == null) {
                print(
                    "PopularProducts FutureBuilder: Snapshot has no data or data is null.");
                return const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Text("No popular products available at the moment."),
                );
              }

              // Safely access 'products' list from snapshot data
              final dynamic productsDataUntyped = snapshot.data!['products'];
              if (productsDataUntyped == null || productsDataUntyped is! List) {
                print(
                    "PopularProducts FutureBuilder: 'products' key missing, null, or not a List. Actual value: $productsDataUntyped");
                return const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Text("Products data is in an unexpected format."),
                );
              }

              final List<dynamic> apiProducts =
                  productsDataUntyped; // Now we know it's a list

              if (apiProducts.isEmpty) {
                print(
                    "PopularProducts FutureBuilder: 'products' list is empty.");
                return const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Text("No popular products found."),
                );
              }

              final List<Product> products =
                  _mapApiResponseToModel(apiProducts);

              if (products.isEmpty && apiProducts.isNotEmpty) {
                print(
                    "PopularProducts FutureBuilder: Mapping resulted in an empty list, but API returned ${apiProducts.length} products.");
                return const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Text("Could not process product data after fetching."),
                );
              }

              if (products.isEmpty) {
                // If still empty after mapping (and apiProducts was not empty but mapping failed for all)
                return const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Text("No displayable popular products."),
                );
              }

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == products.length - 1 ? defaultPadding : 0,
                    ),
                    child: product_card.ProductCard(
                      // Ensure ProductCard is correctly defined and imported
                      image: products[index].image,
                      brandName: products[index].brandName ?? 'Marque inconnue',
                      title: products[index].name,
                      price: products[index].price,
                      priceAfetDiscount: _calculateDiscountPrice(
                        products[index].price,
                        products[index].discountAmount,
                      ),
                      dicountpercent: products[index].discountAmount?.toInt(),
                      press: () => _navigateToDetail(products[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } catch (e, s) {
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print(
          "!!! ERROR OCCURRED WHILE BUILDING PopularProducts WIDGET (Outer Catch) !!!");
      print("Error type: ${e.runtimeType}");
      print("Error message: $e");
      print("Full StackTrace for this error: \n$s");
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      return Container(
        height:
            220, // Give it some consistent height if it's in a constrained space
        alignment: Alignment.center,
        padding: const EdgeInsets.all(defaultPadding),
        child: Text(
          "An error occurred building Popular Products section.\nError: $e",
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  List<Product> _mapApiResponseToModel(List<dynamic> apiProducts) {
    if (kDebugMode) {
      print(
          "PopularProducts: _mapApiResponseToModel attempting to map ${apiProducts.length} products from API.");
    }
    List<Product> mappedProducts = [];
    for (var productData in apiProducts) {
      try {
        if (productData == null || productData is! Map<String, dynamic>) {
          if (kDebugMode)
            print(
                "PopularProducts _mapApiResponseToModel: Skipping invalid product data item (null or not a Map): $productData");
          continue;
        }

        // Check for essential non-null fields before attempting to create a Product
        // Adjust these checks based on what your Product model absolutely requires
        if (productData['id'] == null ||
            productData['name'] == null ||
            productData['image'] == null ||
            productData['price'] == null ||
            productData['devise'] == null) {
          if (kDebugMode)
            print(
                "PopularProducts _mapApiResponseToModel: Skipping product due to missing required fields: $productData");
          continue;
        }

        mappedProducts.add(Product(
          id: productData['id'],
          name: productData['name'] as String,
          image: productData['image'] as String,
          price: double.parse(productData['price'].toString()),
          devise: productData['devise'] as String,
          discountType: productData[
              'discount_type'], // Make sure Product model expects String?
          discountAmount: productData['discount_amount'] == null
              ? null
              : double.tryParse(productData['discount_amount']
                  .toString()), // Fallback to null if parse fails
          brandName: productData['brand_name'] as String?,
          brandLogo: productData['brand_logo'] as String?,
          // Ensure your Product model has 'categoryId' (or 'categoruId' if that's intentional)
          // and it expects a String.
          categoruId: productData['category_id']?.toString() ?? '', url: '',
          images: [],
        ));
      } catch (e, s) {
        if (kDebugMode) {
          print(
              "!!! PopularProducts _mapApiResponseToModel: Error mapping a single product !!!");
          print("Problematic product data: $productData");
          print("Mapping error: $e");
          print("Mapping stack trace: $s");
        }
        // Decide whether to skip this product or rethrow. Skipping allows others to load.
      }
    }
    if (kDebugMode) {
      print(
          "PopularProducts _mapApiResponseToModel: Successfully mapped ${mappedProducts.length} products out of ${apiProducts.length}.");
    }
    return mappedProducts;
  }

  double _calculateDiscountPrice(double price, double? discountAmount) {
    // Ensure discount is valid (e.g., between 0 and 100, not just >0 and <100 if 0 or 100 are valid)
    return discountAmount != null &&
            discountAmount >= 0 &&
            discountAmount <= 100
        ? price * (1 - (discountAmount / 100))
        : price;
  }

  void _navigateToDetail(Product product) {
    if (mounted) {
      Navigator.pushNamed(
        context,
        productDetailsScreenRoute, // Ensure this constant is defined and routes correctly
        arguments: ProductDetailsArguments(
          // Ensure ProductDetailsArguments is defined
          product: product,
          isFromAPI: true,
        ),
      );
    }
  }
}

// Ensure ProductsSkelton is defined, e.g.:
class ProductsSkelton extends StatelessWidget {
  const ProductsSkelton({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide a more visually representative skeleton if possible
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Example count
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Container(
            width: 150,
            height: 220,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(defaultPadding / 2)),
          ),
        ),
      ),
    );
  }
}

// Ensure Skelton class is defined if used by ProductsSkelton (it was in your original code)
class Skelton extends StatelessWidget {
  final double? width, height;
  const Skelton({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface
            .withOpacity(0.5), // Example color
        borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
      ),
    );
  }
}

// NOTE:
// 1. Ensure your `Product` model (from `package:shop/models/product_model.dart`)
//    matches the fields and types used in `_mapApiResponseToModel`.
//    Specifically, check the type of `discountType` and `categoruId`.
//
// 2. Ensure `ProductCard` (from `package:shop/components/product/product_card.dart`)
//    and `ProductDetailsArguments` (from `../../../../models/product_details_arguments.dart`)
//    are correctly defined and their parameters match what's being passed.
//
// 3. Ensure all constants like `defaultPadding`, `primaryColor`, `productDetailsScreenRoute`
//    are correctly defined and imported from `constants.dart` and `screen_export.dart`.