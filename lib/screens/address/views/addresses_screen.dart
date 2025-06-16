import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Adresses')),
      body: const Center(
        child: Text('هادي هي صفحة العناوين ديالك'),
      ),
    );
  }
}
