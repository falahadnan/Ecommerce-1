import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importer le package provider
import 'package:shop/constants.dart';
import 'package:shop/models/cart_item.dart'; // Ce modèle est toujours utile
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/cart_service.dart';

// CORRIGÉ: On peut maintenant utiliser un StatelessWidget car l'état est géré par Provider.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // On utilise un Consumer pour écouter les changements du CartService et reconstruire l'UI.
    return Consumer<CartService>(
      builder: (context, cartService, child) {
        // 'child' est utilisé pour les parties qui ne doivent pas se reconstruire, comme le message "panier vide".
        return Scaffold(
          appBar: AppBar(title: const Text("Mon Panier")),
          body: cartService.items.isEmpty
              ? child! // Affiche le message "Votre panier est vide"
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartService.items.length,
                        itemBuilder: (context, index) {
                          final item = cartService.items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.product.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image, size: 80);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "${item.product.price.toStringAsFixed(2)} €",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            // CORRIGÉ: Appel des méthodes du service avec le productId
                                            _qtyButton(
                                                Icons.remove,
                                                () => cartService.decrementQuantity(item.product.id),
                                                Colors.grey[300]!),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text("${item.quantity}"),
                                            ),
                                            _qtyButton(
                                                Icons.add,
                                                () => cartService.incrementQuantity(item.product.id),
                                                Theme.of(context).primaryColor),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    // CORRIGÉ: Appel de removeItem avec le productId
                                    onPressed: () => cartService.removeItem(item.product.id),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Le container du bas est reconstruit avec les nouvelles données
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${cartService.totalPrice.toStringAsFixed(2)} €",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, paymentScreenRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Passer au paiement"),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        );
      },
      // Le widget 'child' est passé au builder. Il est utile pour les parties de l'UI
      // qui n'ont pas besoin de changer quand le service notifie ses écouteurs.
      child: const Center(
        child: Text("Votre panier est vide"),
      ),
    );
  }

  // Ce widget d'aide peut rester ici car il est purement visuel
  Widget _qtyButton(IconData icon, VoidCallback onPressed, Color color) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}