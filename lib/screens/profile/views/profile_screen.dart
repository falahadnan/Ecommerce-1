import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/services/api_client.dart';
import 'package:shop/services/auth_service.dart';
import 'package:shop/services/user_service.dart';
import 'package:shop/user_api.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      final scaffold = ScaffoldMessenger.of(context);
      await AuthService.logout();

      Navigator.of(context).pushNamedAndRemoveUntil(
          logInScreenRoute, (Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la déconnexion: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Rafraîchir les données utilisateur
        },
        child: ListView(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: UserService.fetchUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildProfileShimmer();
                }
                if (snapshot.hasError) {
                  return _buildErrorWidget(context, snapshot.error.toString());
                }

                final user = snapshot.data?['user'];
                return ProfileCard(
                  name: user?['name'] ?? 'Utilisateur',
                  email: user?['email'] ?? '',
                  imageSrc: user?['image'] ?? '',
                  membershipLevel: 'Membre Or', // Ajout d'un niveau de membre
                  press: () {
                    Navigator.pushNamed(context, userInfoScreenRoute);
                  },
                );
              },
            ),

            const SizedBox(height: defaultPadding),

            // Bannière promotionnelle

            const SizedBox(height: defaultPadding * 1.5),

            // Section Compte
            _buildSectionHeader(context, "Compte"),
            _buildMenuItem(
              context,
              "Mes Commandes",
              Icons.shopping_bag_outlined,
              () => Navigator.pushNamed(context, ordersScreenRoute),
            ),
            _buildMenuItem(
              context,
              "Liste de Souhaits",
              Icons.favorite_border,
              () => Navigator.pushNamed(context, wishlistScreenRoute),
            ),
            _buildMenuItem(
              context,
              "Mes Adresses",
              Icons.location_on_outlined,
              () => Navigator.pushNamed(context, addressesScreenRoute),
            ),
            _buildMenuItem(
              context,
              "Moyens de Paiement",
              Icons.credit_card,
              () => Navigator.pushNamed(context, paymentScreenRoute),
            ),
            _buildMenuItem(
              context,
              "Portefeuille",
              Icons.account_balance_wallet_outlined,
              () => Navigator.pushNamed(context, walletScreenRoute),
               // Solde du portefeuille
            ),

            const SizedBox(height: defaultPadding),

            // Section Paramètres
            _buildSectionHeader(context, "Paramètres"),
            _buildMenuItem(
              context,
              "Notifications",
              Icons.notifications_none,
              () => Navigator.pushNamed(context, notificationsScreenRoute),
              trailingText: "Activée",
            ),
            _buildMenuItem(
              context,
              "Préférences",
              Icons.settings_outlined,
              () => Navigator.pushNamed(context, preferencesScreenRoute),
            ),
            _buildMenuItem(
              context,
              "Langue",
              Icons.language,
              () => Navigator.pushNamed(context, selectLanguageScreenRoute),
              trailingText: "Français",
            ),

            const SizedBox(height: defaultPadding),

            // Section Aide
            _buildSectionHeader(context, "Aide & Support"),
            _buildMenuItem(
              context,
              "Centre d'Aide",
              Icons.help_outline,
              () => Navigator.pushNamed(context, getHelpScreenRoute),
            ),
            _buildMenuItem(
              context,
              "FAQ",
              Icons.question_answer_outlined,
              () => Navigator.pushNamed(context, faqScreenRoute),
            ),
            _buildMenuItem(
              context,
              "Nous Contacter",
              Icons.email_outlined,
              () => Navigator.pushNamed(context, contactUsScreenRoute),
            ),

            const SizedBox(height: defaultPadding * 2),

            // Bouton de déconnexion
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: errorColor),
                label: const Text(
                  "Déconnexion",
                  style: TextStyle(color: errorColor),
                ),
                onPressed: () => _logout(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: errorColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: defaultPadding, vertical: defaultPadding / 2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    int? badgeCount,
    int? itemsCount,
    String? trailingText,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badgeCount != null)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          if (itemsCount != null)
            Text(
              '$itemsCount',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (trailingText != null)
            Text(
              trailingText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildProfileShimmer() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Réessayer de charger
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String imageSrc;
  final String? membershipLevel;
  final int? points;
  final VoidCallback press;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageSrc,
    this.membershipLevel,
    this.points,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.all(defaultPadding),
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(imageSrc.isNotEmpty
                  ? imageSrc
                  : 'https://i.imgur.com/8Km9tLL.jpg'),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (membershipLevel != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Text(
                        membershipLevel!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.amber[800],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                  if (points != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$points points de fidélité',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ma liste de souhaits')),
      body: const Center(child: Text('Page Wishlist')),
    );
  }
}
