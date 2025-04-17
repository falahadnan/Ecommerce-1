import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  final String token;

  const GalleryScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: Center(
        child: Text("Token: $token"),
      ),
    );
  }
}
