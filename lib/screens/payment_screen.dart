import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  // On le transforme en StatefulWidget pour gérer l'état de la sélection
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Variable pour garder en mémoire la méthode de paiement sélectionnée
  int? _selectedPaymentMethodIndex;

  // Liste des moyens de paiement disponibles (vous pouvez la remplir dynamiquement)
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'Carte de Crédit',
      'subtitle': '**** **** **** 4242',
      'icon': Icons.credit_card,
    },
    {
      'title': 'PayPal',
      'subtitle': 'compte@email.com',
      'icon': Icons.paypal, // L'icône PayPal est disponible dans certains packs
    },
    {
      'title': 'Apple Pay',
      'subtitle': 'Utiliser votre compte Apple Pay',
      'icon': Icons.apple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moyens de Paiement'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1, // Une légère ombre sous la barre d'application
      ),
      backgroundColor: Colors.grey[100], // Un fond légèrement grisé
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Le texte traduit et amélioré
            const Text(
              'Choisissez votre moyen de paiement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Crée la liste des cartes de paiement à partir de la liste _paymentMethods
            ListView.builder(
              shrinkWrap: true, // Pour que la ListView prenne juste la place nécessaire
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RadioListTile<int>(
                    value: index, // La valeur unique pour ce bouton radio
                    groupValue: _selectedPaymentMethodIndex, // L'état actuel de la sélection
                    onChanged: (int? value) {
                      // Met à jour l'état quand l'utilisateur sélectionne une option
                      setState(() {
                        _selectedPaymentMethodIndex = value;
                      });
                    },
                    title: Text(
                      method['title'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(method['subtitle']),
                    secondary: Icon(
                      method['icon'],
                      color: Theme.of(context).primaryColor,
                    ),
                    activeColor: Theme.of(context).primaryColor,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),

            // Option pour ajouter une nouvelle méthode de paiement
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.add, color: Colors.green),
                title: const Text(
                  'Ajouter un nouveau moyen de paiement',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Mettez ici la logique pour naviguer vers la page d'ajout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigation vers la page d\'ajout...')),
                  );
                },
              ),
            ),

            const Spacer(), // Pousse le bouton vers le bas de l'écran

            // Bouton de confirmation
            SizedBox(
              width: double.infinity, // Le bouton prend toute la largeur
              child: ElevatedButton(
                onPressed: _selectedPaymentMethodIndex == null
                    ? null // Désactive le bouton si rien n'est sélectionné
                    : () {
                        // Logique à exécuter lors du paiement
                        final selectedMethod = _paymentMethods[_selectedPaymentMethodIndex!];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Paiement avec ${selectedMethod['title']}...')),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Payer Maintenant',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}