import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/services/api_service.dart';
import 'package:shop/services/language_service.dart';
import 'package:shop/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import crucial

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider pour le service API
        Provider<ApiService>(
          create: (_) => ApiService(),
          dispose: (_, apiService) => apiService.dispose(),
        ),

        // Provider pour le service de langue
        Provider<LanguageService>(
          create: (context) => LanguageService(context.read<ApiService>()),
        ),

        // Ajoutez d'autres providers ici selon vos besoins
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',

      // Configuration du thème
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context), // Optionnel
      themeMode: ThemeMode.light,

      locale: const Locale('fr', 'FR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // Français
        // Vous pouvez ajouter d'autres langues si besoin :
        // Locale('en', 'US'), // Anglais
      ],

      // Gestion des routes
      onGenerateRoute: router.generateRoute,
      initialRoute: onbordingScreenRoute,

      // Configuration supplémentaire
      //locale: const Locale('fr', 'FR'), // Pour le français
      //supportedLocales: const [Locale('fr', 'FR')],
    );
  }
}
