import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma liste de souhaits')),
      body: const Center(child: Text('هادي صفحة قائمة الأمنيات ديالك')),
    );
  }
}
