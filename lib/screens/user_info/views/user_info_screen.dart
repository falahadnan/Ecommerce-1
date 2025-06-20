import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data, تقدر تجيب البيانات من API ولا Service
    final Map<String, String> userData = {
      'Nom': 'Ahmed El Khattabi',
      'Email': 'tehdbehdh@tehdbehdh.com',
      'Téléphone': '+212 612 345 678',
      'Adresse': 'Casablanca, Maroc',
      'Date de naissance': '12/03/1994',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails du Profil"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, editProfileScreenRoute);
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: userData.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          String key = userData.keys.elementAt(index);
          return ListTile(
            title: Text(key),
            subtitle: Text(userData[key]!),
            leading: const Icon(Icons.person_outline),
          );
        },
      ),
    );
  }
}
