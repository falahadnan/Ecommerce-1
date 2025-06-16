import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/route/screen_export.dart';
import 'package:shop/theme/app_theme.dart';
import 'package:shop/token_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Crucial
  await TokenManager().loadTokenFromStorage(); // Load token before app runs
  // ApiClient.initialize(); // If you had an initialize method for ApiClient interceptors later
  runApp(const MyApp()); // Assuming your root widget is MyApp
}

// Thanks for using our template. You are using the free version of the template.
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

class MyApp extends StatelessWidget {
  const MyApp({super.key, navigatorKey});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Shop Template by The Flutter Way',
      theme: AppTheme.lightTheme(context),
      // Dark theme is inclided in the Full template
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: onbordingScreenRoute,
    );
  }
}
