import 'package:flutter/material.dart';
import 'package:shop/components/Banner/S/banner_s_style_1.dart';
import 'package:shop/components/Banner/S/banner_s_style_5.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
// import 'package:shop/screens/home/views/components/bast_sellers.dart'; // supprimé
// import 'components/best_sellers.dart'; // supprimé
// import 'components/flash_sale.dart'; // supprimé
// import 'components/most_popular.dart'; // supprimé
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- ADD PRINT STATEMENT TO SEE WHEN THIS BUILDS ---
    print("--- Building HomeScreen ---");

    try {
      // <--- START OF THE TRY BLOCK
      return Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
              const SliverToBoxAdapter(child: PopularProducts()),
              // const SliverPadding(
              //   padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              //   sliver: SliverToBoxAdapter(child: FlashSale()),
              // ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // While loading use 👇
                    // const BannerMSkelton(),‚
                   // BannerSStyle1(
                     // title: "New \narrival",
                      //subtitle: "SPECIAL OFFER",
                      //discountParcent:
                        //  50, // Make sure this is 'discountPercent' if the widget expects that spelling
                      //press: () {
                        //Navigator.pushNamed(context, onSaleScreenRoute);
                      //},
                    //),
                    const SizedBox(height: defaultPadding / 4),
                    // We have 4 banner styles, all in the pro version
                  ],
                ),
              ),
              // const SliverToBoxAdapter(child: BestSellers()), // supprimé
              // const SliverToBoxAdapter(child: MostPopular()), // supprimé
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: defaultPadding * 1.5),
                    const SizedBox(height: defaultPadding / 4),
                    // While loading use 👇
                    // const BannerSSkelton(),
                    //BannerSStyle5(
                      //title: "Black \nfriday",
                      //subtitle: "50% Off",
                      //bottomText: "Collection".toUpperCase(),
                      //press: () {
                        //Navigator.pushNamed(context, onSaleScreenRoute);
                      //},
                    //),
                    const SizedBox(height: defaultPadding / 4),
                  ],
                ),
              ),
              // const SliverToBoxAdapter(child: BestSellers()), // supprimé
            ],
          ),
        ),
      );
    } catch (e, s) {
      // <--- CATCH BLOCK
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      print("!!! ERROR OCCURRED WHILE BUILDING HomeScreen !!!");
      print("Error type: ${e.runtimeType}");
      print("Error message: $e");
      print(
          "Full StackTrace for this error: \n$s"); // <--- THIS IS THE STACK TRACE WE NEED
      print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      // Return a fallback UI
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Error building HomeScreen. Check console for details.\n\nError: $e",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}
