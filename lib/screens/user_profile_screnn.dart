import 'package:flutter/material.dart';
import 'package:shop/services/user_service.dart';
import 'package:shop/user_api.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    UserService.fetchUser().then((data) {
      setState(() {
        userData = data['user'];
        // Correction ici :
        userData?['image'] = data['avatar'];
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

    // On prend l'image de userData['image'] ou de userData['avatar'], sinon image par défaut
    final imageUrl =
        (userData!['image'] != null && userData!['image'].toString().isNotEmpty)
            ? userData!['image']
            : (userData!['avatar'] != null &&
                    userData!['avatar'].toString().isNotEmpty)
                ? userData!['avatar']
                : 'https://i.imgur.com/IXnwbLk.png';

    return Scaffold(
      appBar: AppBar(title: const Text('Profil utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nom : ${userData!['name']}'),
            Text('Email : ${userData!['email']}'),
            Text('Type : ${userData!['type_website']}'),
            // Ajoute d'autres champs si besoin
          ],
        ),
      ),
    );
  }
}
