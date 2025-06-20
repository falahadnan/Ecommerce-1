import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- IMPORT NÉCESSAIRE
import 'package:shop/services/cart_service.dart'; // <-- IMPORT NÉCESSAIRE
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';
import 'package:shop/token_manager.dart';
import 'package:shop/route/route_constants.dart';

// La clé globale est conservée, elle n'interfère pas.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Votre logique de démarrage asynchrone est conservée
  WidgetsFlutterBinding.ensureInitialized();
  await TokenManager().loadTokenFromStorage();

  // CORRECTION : On enveloppe l'application avec le Provider ici
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartService(), // Crée l'instance unique du service
      child:
          const MyApp(), // Votre application MyApp est maintenant un enfant du Provider
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Ce widget est la racine de votre application, sa configuration est conservée.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Shop Template by The Flutter Way',
      // Votre thème personnalisé est conservé
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      // Votre système de routage personnalisé est conservé
      onGenerateRoute: router.generateRoute,
      initialRoute: onbordingScreenRoute,
    );
  }
}
