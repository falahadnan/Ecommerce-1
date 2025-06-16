import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moyens de Paiement')),
      body: const Center(
        child: Text('هادي هي صفحة وسائل الأداء ديالك'),
      ),
    );
  }
}
