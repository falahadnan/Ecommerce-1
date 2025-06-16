import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

abstract class AppColors {
  static const primary = Color(0xFF0066FF); // Main blue from devaito.com
  static const primaryDark = Color(0xFF0052CC); // Darker blue
  static const accent =
      Color.fromARGB(255, 0, 214, 143); // Green accent from devaito.com

  static const textPrimary = Color(0xFF1A1F36); // Dark text from devaito.com
  static const textSecondary = Color(0xFF697386); // Gray text from devaito.com

  static const background = Color(0xFFFFFFFF); // White background
  static const card =
      Color(0xFFF7F9FC); // Light gray for cards from devaito.com
}

// Just for demo
const productDemoImg1 = "https://i.imgur.com/CGCyp1d.png";
const productDemoImg2 = "https://i.imgur.com/AkzWQuJ.png";
const productDemoImg3 = "https://i.imgur.com/J7mGZ12.png";
const productDemoImg4 = "https://i.imgur.com/q9oF9Yq.png";
const productDemoImg5 = "https://i.imgur.com/MsppAcx.png";
const productDemoImg6 = "https://i.imgur.com/JfyZlnO.png";

// End For demo

const grandisExtendedFont = "Grandis Extended";

// Main colors from devaito.com
const Color primaryColor = Color(0xFF0066FF); // Main blue
const MaterialColor primaryMaterialColor = MaterialColor(
  0xFF0066FF,
  <int, Color>{
    50: Color(0xFFE5F0FF),
    100: Color(0xFFB3D1FF),
    200: Color(0xFF80B3FF),
    300: Color(0xFF4D94FF),
    400: Color(0xFF1A7FFF),
    500: Color(0xFF0066FF), // Primary blue
    600: Color(0xFF0052CC),
    700: Color(0xFF003D99),
    800: Color(0xFF002966),
    900: Color(0xFF001433),
  },
);

// Black color variations from devaito.com
const Color blackColor = Color(0xFF1A1F36); // True black
const Color blackColor80 = Color(0xFF424B62); // 80% black
const Color blackColor60 = Color(0xFF697386); // 60% black
const Color blackColor40 = Color(0xFF8F96A3); // 40% black
const Color blackColor20 = Color(0xFFB5BAC3); // 20% black
const Color blackColor10 = Color(0xFFDADCE1); // 10% black
const Color blackColor5 = Color(0xFFECEDF0); // 5% black

// White color variations
const Color whiteColor = Colors.white;
const Color whiteColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

// Updated grey colors to match devaito.com
const Color greyColor = Color(0xFF697386); // Main grey
const Color lightGreyColor = Color(0xFFF7F9FC); // Light grey background
const Color darkGreyColor = Color(0xFF1A1F36); // Dark grey

// Accent and status colors from devaito.com
const Color purpleColor = Color(0xFF7B61FF); // Purple accent
const Color successColor = Color(0xFF00D68F); // Success green
const Color warningColor = Color(0xFFFFAB00); // Warning amber
const Color errorColor = Color(0xFFFF3B3B); // Error red

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

const pasNotMatchErrorText = "passwords do not match";

// Ajoutez dans constants.dart
const productCardBorderRadius = 12.0;
const productCardPadding = 8.0;
const productImageHeight = 120.0;

// Mauvais
// final String baseUrl = 'https://ton-api.com';

// Bon (exemples)
const String baseUrl = 'https://admine.skaidev.com';
// ou pour un backend local sur un émulateur Android :
// const String baseUrl = 'http://10.0.2.2:8000';