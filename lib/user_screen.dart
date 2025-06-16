import 'package:flutter/material.dart';
import 'package:shop/services/user_service.dart';
import 'package:shop/user_api.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    UserService.fetchUser().then((data) {
      setState(() {
        userData = data['user'];
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));
    if (userData == null) return const Center(child: Text('No user data'));

    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: userData!['image'] != null
                    ? NetworkImage(userData!['image'])
                    : const NetworkImage(
                        'https://i.imgur.com/IXnwbLk.png'), // image par défaut
              ),
            ),
            const SizedBox(height: 16),
            Text('Name: ${userData!['name']}'),
            Text('Email: ${userData!['email']}'),
            Text('Type: ${userData!['type_website']}'),
            // Ajoute d'autres champs si besoin
          ],
        ),
      ),
    );
  }
}
