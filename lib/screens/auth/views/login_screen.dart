import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/auth_service.dart'; // Your AuthService

import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false; // Added for loading state indication

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      try {
        // Appel à l'API via le service d'authentification
        await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // ---- START OF THE CRITICAL SECTION TO DEBUG ----
        print("LoginScreen: AuthService.login completed. Attempting navigation...");
        try {
          // Redirection vers l'écran principal avec nettoyage de la pile
          if (mounted) { // Check if the widget is still in the tree before navigating
            Navigator.pushNamedAndRemoveUntil(
              context,
              entryPointScreenRoute, // Make sure this route is correctly defined
              (Route<dynamic> route) => false,
            );
            print("LoginScreen: Navigation initiated without immediate error.");
          } else {
            print("LoginScreen: Widget not mounted, cannot navigate.");
          }
        } catch (e, s) { // 's' is the StackTrace object
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print("!!! LoginScreen: ERROR OCCURRED IMMEDIATELY AFTER AuthService.login RETURNED !!!");
          print("!!! THIS IS LIKELY THE 'Null check operator' ERROR WE ARE LOOKING FOR !!!");
          print("Error type: ${e.runtimeType}");
          print("Error message: $e");
          print("Full StackTrace for this error: \n$s");
          print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("An error occurred after login: $e. Check console for details."))
            );
          }
        }
        // ---- END OF THE CRITICAL SECTION TO DEBUG ----

      } catch (e) {
        // Gestion des erreurs from AuthService.login itself
        print("LoginScreen: Login attempt itself failed: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/logo/LOGOCARS.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your data that you intered during your registration.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: _isLoading ? null : () { // Disable if loading
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin, // Disable if loading
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text("Log in"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: _isLoading ? null : () { // Disable if loading
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Sign up"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}