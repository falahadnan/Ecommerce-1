import 'package:flutter/material.dart';

// Étape 1 : Créer un modèle pour représenter une Adresse
// C'est une meilleure pratique que d'utiliser des Maps, car c'est plus sûr et plus clair.
class Address {
  final int id;
  final String title; // Ex: "Domicile", "Bureau"
  final String recipientName;
  final String street;
  final String city;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.title,
    required this.recipientName,
    required this.street,
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });
}

// Étape 2 : Transformer le widget en StatefulWidget pour gérer les données
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  // Liste d'adresses de démonstration. Dans une vraie application,
  // ces données viendraient d'une base de données ou d'une API.
  final List<Address> _addresses = [
    Address(
      id: 1,
      title: 'Domicile',
      recipientName: 'Jean Dupont',
      street: '123 Rue de la République',
      city: 'Paris',
      postalCode: '75001',
      isDefault: true,
    ),
    Address(
      id: 2,
      title: 'Bureau',
      recipientName: 'Jean Dupont',
      street: '456 Avenue des Champs-Élysées',
      city: 'Paris',
      postalCode: '75008',
    ),
  ];

  // Fonction pour supprimer une adresse (pour la démo)
  void _deleteAddress(int id) {
    setState(() {
      _addresses.removeWhere((address) => address.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adresse supprimée avec succès.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Adresses'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Le texte traduit et amélioré
            const Text(
              'Gérez vos adresses de livraison',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // La liste va occuper l'espace disponible
            Expanded(
              child: _addresses.isEmpty
                  ? const Center(
                      child: Text(
                      'Vous n\'avez aucune adresse enregistrée.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ))
                  : ListView.builder(
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        final address = _addresses[index];
                        return _buildAddressCard(address);
                      },
                    ),
            ),

            const SizedBox(height: 16),

            // Bouton pour ajouter une nouvelle adresse
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Ajouter une nouvelle adresse'),
                onPressed: () {
                  // Mettez ici la logique pour ouvrir une page/un formulaire d'ajout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ouverture du formulaire d\'ajout...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget personnalisé pour afficher une carte d'adresse
  Widget _buildAddressCard(Address address) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: address.isDefault
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  address.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (address.isDefault)
                  Chip(
                    label: const Text('Par Défaut'),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    padding: EdgeInsets.zero,
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text(address.recipientName),
            const SizedBox(height: 4),
            Text(address.street),
            const SizedBox(height: 4),
            Text('${address.postalCode}, ${address.city}'),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Modifier'),
                  onPressed: () {
                    // Logique pour modifier l'adresse
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: Colors.red[700]),
                  label: Text('Supprimer',
                      style: TextStyle(color: Colors.red[700])),
                  onPressed: () => _deleteAddress(address.id),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
