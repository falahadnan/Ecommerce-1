import 'package:flutter/material.dart';
import 'package:shop/category_screens.dart';
import 'package:shop/entry_point.dart';

import 'package:flutter/material.dart';
import 'package:shop/products_screen.dart';
import 'package:shop/screens/EditProfileScreen.dart';
import 'package:shop/screens/payment_screen.dart';
// import 'package:shop/screens/product_details.dart';
// import 'package:shop/screens/wallet_screen.dart';
import 'package:shop/select_laguage_screen.dart';
import 'package:shop/services/cart_service.dart';

import '../screens/wallet_screen.dart' as wallet_screen;
import 'screen_export.dart';
import 'package:shop/screens/faq/faq_screen.dart';
import 'package:shop/screens/contact/contact_us_screen.dart';
import 'package:shop/screens/promotion/promotion_screen.dart';
import 'package:shop/screens/settings/settings_screen.dart';
import 'package:shop/screens/payment/payment_method_screen.dart'; // adapte le chemin si besoin
import 'package:shop/screens/notification/view/notificatios_screen.dart'; // adapte le chemin si besoin
import 'package:shop/screens/language/views/select_language_screen.dart';
import 'package:shop/screens/category_detail_screen.dart';
import 'package:shop/models/product_details_arguments.dart';

// Yuo will get 50+ screens and more once you have the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

// NotificationPermissionScreen()
// PreferredLanguageScreen()
// SelectLanguageScreen()
// SignUpVerificationScreen()
// ProfileSetupScreen()
// VerificationMethodScreen()
// OtpScreen()
// SetNewPasswordScreen()
// DoneResetPasswordScreen()
// TermsOfServicesScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFaceIdScreen()
// OnSaleScreen()
// BannerLStyle2()
// BannerLStyle3()
// BannerLStyle4()
// SearchScreen()
// SearchHistoryScreen()
// NotificationsScreen()
// EnableNotificationScreen()
// NoNotificationScreen()
// NotificationOptionsScreen()
// ProductInfoScreen()
// ShippingMethodsScreen()
// ProductReviewsScreen()
// SizeGuideScreen()
// BrandScreen()
// CartScreen()
// EmptyCartScreen()
// PaymentMethodScreen()
// ThanksForOrderScreen()
// CurrentPasswordScreen()
// EditUserInfoScreen()
// OrdersScreen()
// OrderProcessingScreen()
// OrderDetailsScreen()
// CancleOrderScreen()
// DelivereOrdersdScreen()
// AddressesScreen()
// NoAddressScreen()
// AddNewAddressScreen()
// ServerErrorScreen()
// NoInternetScreen()
// ChatScreen()
// DiscoverWithImageScreen()
// SubDiscoverScreen()
// AddNewCardScreen()
// EmptyPaymentScreen()
// GetHelpScreen()

// ℹ️ All the comments screen are included in the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    // case preferredLanuageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PreferredLanguageScreen(),
    //   );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case '/categoryDetail':
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => CategoryDetailScreen(
          id: args['id'],
          name: args['name'],
          slug: args['slug'],
          imageUrl: args['imageUrl'],
        ),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    // case profileSetupScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProfileSetupScreen(),
    //   );
    case passwordRecoveryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PasswordRecoveryScreen(),
      );
    // case verificationMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const VerificationMethodScreen(),
    //   );
    // case otpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OtpScreen(),
    //   );
    // case newPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetNewPasswordScreen(),
    //   );
    // case doneResetPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DoneResetPasswordScreen(),
    //   );
    // case termsOfServicesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const TermsOfServicesScreen(),
    //   );
    // case noInternetScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoInternetScreen(),
    //   );
    // case serverErrorScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ServerErrorScreen(),
    //   );
    // case signUpVerificationScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SignUpVerificationScreen(),
    //   );
    // case setupFingerprintScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetupFingerprintScreen(),
    //   );
    // case setupFaceIdScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SetupFaceIdScreen(),
    //   );
    // case productDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) {
    //       bool isProductAvailable = settings.arguments as bool? ?? true;
    //       return ProductDetailsScreen(isProductAvailable: isProductAvailable);
    //     },
    //   );
    case productReviewsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProductReviewsScreen(),
      );
    // case addReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddReviewScreen(),
    //   );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    // case brandScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const BrandScreen(),
    //   );
    // case discoverWithImageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DiscoverWithImageScreen(),
    //   );
    // case subDiscoverScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SubDiscoverScreen(),
    //   );

    case onSaleScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnSaleScreen(),
      );
    case kidsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const KidsScreen(),
      );
    case searchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    // case searchHistoryScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SearchHistoryScreen(),
    //   );
    case bookmarkScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const BookmarkScreen(),
      );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
    // case getHelpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const GetHelpScreen(),
    //   );
    // case chatScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ChatScreen(),
    //   );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    // case currentPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CurrentPasswordScreen(),
    //   );
    // case editUserInfoScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EditUserInfoScreen(),
    //   );
    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    case noNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    case enableNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EnableNotificationScreen(),
      );

    case selectLanguageScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SelectLanguageScreen(),
      );
    // case noAddressScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoAddressScreen(),
    //   );
    case addressesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const AddressesScreen(),
      );
    // case addNewAddressesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewAddressScreen(),
    //   );
    case ordersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OrdersScreen(),
      );
    // case orderProcessingScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderProcessingScreen(),
    //   );
    // case orderDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderDetailsScreen(),
    //   );
    // case cancleOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancleOrderScreen(),
    //   );
    // case deliveredOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DelivereOrdersdScreen(),
    //   );
    // case cancledOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancledOrdersScreen(),
    //   );
    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    // case emptyPaymentScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyPaymentScreen(),
    //   );

    case walletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const wallet_screen.WalletScreen(),
      );
    case cartScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CartScreen(),
      );
    case paymentScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PaymentScreen(),
      );
    // case addNewCardScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewCardScreen(),
    //   );
    // case thanksForOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ThanksForOrderScreen(),
    //   );

    // case languageScreenRoute:
    //  return MaterialPageRoute(
    //  builder: (context) => const LanguageScreen(),
    //);

    //case colorsScreenRoute:
    //return MaterialPageRoute(
    //builder: (context) => const ColorsScreen(),
    //);

    //case mediaScreenRoute:
    //return MaterialPageRoute(
    //builder: (context) => const  MediaScreen(),
    //);

    //case productsScreenRoute:
    //return MaterialPageRoute(
    //builder: (context) => const ProductsScreen(),
    //);

    //case storeScreenRoute:
    //return MaterialPageRoute(
    //builder: (context) => const StoreScreen(),
    //);

    //case categoriesScreenRoute:
    //return MaterialPageRoute(
    // builder: (_) => const CategoriesScreen()
    //);

    case categoriesScreenRoute:
      return MaterialPageRoute(builder: (_) => const CategoriesScreen());

    case '/products':
      var demoProducts;
      return MaterialPageRoute(
          builder: (_) => ProductsScreen(products: demoProducts));
    case '/cart':
      return MaterialPageRoute(builder: (_) => const CartScreen());

    case '/user':
      return MaterialPageRoute(builder: (_) => const UserInfoScreen());

    case ordersScreenRoute:
      return MaterialPageRoute(builder: (_) => const OrdersScreen());

    case wishlistScreenRoute:
      return MaterialPageRoute(builder: (_) => const WishlistScreen());

    case editProfileScreenRoute:
      return MaterialPageRoute(builder: (_) => const EditProfileScreen());

    case productDetailsScreenRoute:
      final args = settings.arguments as ProductDetailsArguments;
      return MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(product: args.product),
      );

    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        ),
      );
  }
}
