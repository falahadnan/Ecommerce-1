import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  String? storePrompt;

  @override
  void initState() {
    super.initState();
    loadStorePrompt();
  }

  void loadStorePrompt() async {
    // try {
    //   final data = await apiService.getStorePrompt();
    //   setState(() {
    //     storePrompt = data['prompt']; // Adjust based on the actual response
    //   });
    // } catch (e) {
    //   setState(() {
    //     storePrompt = 'Erreur lors du chargement';
    //   });
    //   print(e);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Prompt')),
      body: Center(
        child: storePrompt == null
            ? const CircularProgressIndicator()
            : Text(
                storePrompt!,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
