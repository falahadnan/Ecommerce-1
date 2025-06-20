import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';

import 'banner_m.dart';
import '../../../constants.dart';

class BannerItem {
  final String url;
  final String type; // 'image' ou 'video'
  final String title;
  final int discountParcent;

  BannerItem({
    required this.url,
    required this.type,
    required this.title,
    required this.discountParcent,
  });

  // Ce constructeur factory n'est plus utilisé car on construit
  // l'objet différemment, mais on peut le garder au cas où.
  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
        url: json['url'] ?? '',
        type: json['type'] ?? 'image',
        title: json['title'] ?? 'Titre par défaut',
        discountParcent: int.tryParse(json['discountParcent'].toString()) ?? 0,
      );
}

class BannerMStyle3 extends StatefulWidget {
  // Le constructeur a été simplifié
  const BannerMStyle3({super.key});

  @override
  State<BannerMStyle3> createState() => _BannerMStyle3State();
}

class _BannerMStyle3State extends State<BannerMStyle3> {
  late Future<List<BannerItem>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    _bannersFuture = fetchBanners();
  }

  // --- FONCTION fetchBanners ENTIÈREMENT CORRIGÉE ---
  Future<List<BannerItem>> fetchBanners() async {
    // Note: Le token n'est peut-être pas nécessaire pour cette URL,
    // mais il est bon de le garder si d'autres le requièrent.
    const String token = '2279|thAJPDeXLdN4j2dmIqHVeGG5flDvbdoccHHcVMuN'; // Votre token réel
    final dio = Dio();

    try {
      // On appelle la bonne URL
      final response = await dio.get(
        'https://test666.skaidev.com/api/gallery-store',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // 1. Récupérer la liste d'URLs depuis la clé "all_urls"
        final List<dynamic> urlList = response.data['all_urls'];

        // 2. Créer une liste pour stocker nos objets BannerItem
        final List<BannerItem> banners = [];

        // 3. Boucler sur chaque URL pour créer un BannerItem
        for (var url in urlList) {
          if (url is String && url.isNotEmpty) {
            // 4. Déduire le type à partir de l'extension de l'URL
            String type = 'image'; // Par défaut, c'est une image
            if (url.endsWith('.mp4') ||
                url.endsWith('.mov') ||
                url.endsWith('.avi')) {
              type = 'video';
            }

            // 5. Créer l'objet BannerItem avec des valeurs par défaut
            banners.add(
              BannerItem(
                url: url,
                type: type,
                title: "Offre Spéciale", // Titre par défaut
                discountParcent: 15, // Pourcentage par défaut
              ),
            );
          }
        }
        return banners;
      } else {
        throw Exception('Erreur de chargement: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        print('Erreur Dio dans fetchBanners: ${e.response?.data}');
      } else {
        print('Erreur générique dans fetchBanners: $e');
      }
      throw Exception('Impossible de charger les bannières: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Le reste du code de build est bon et n'a pas besoin de changer !
    // Il va maintenant recevoir la bonne liste de BannerItem.
    return SizedBox(
      height: 220,
      child: FutureBuilder<List<BannerItem>>(
        future: _bannersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final banners = snapshot.data ?? [];
          if (banners.isEmpty) {
            return const Center(child: Text('Aucune bannière trouvée.'));
          }
          
          return PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return BannerM(
                image: banner.type == 'image' ? banner.url : '',
                press: () {},
                children: [
                   // Afficher la vidéo en fond si c'est une vidéo
                  if (banner.type == 'video')
                    _BannerVideoPlayer(url: banner.url),

                  // Le contenu textuel par-dessus
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding / 2,
                                    vertical: defaultPadding / 8),
                                color: Colors.white70,
                                child: Text(
                                  "${banner.discountParcent}% off",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: defaultPadding / 2),
                              Text(
                                banner.title.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'GrandisExtended', // Remplacez par votre constante
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: defaultPadding),
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.white,
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/Arrow - Right.svg",
                              colorFilter: const ColorFilter.mode(
                                  Colors.black, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Le widget vidéo reste le même, mais j'ajoute quelques améliorations
class _BannerVideoPlayer extends StatefulWidget {
  final String url;
  const _BannerVideoPlayer({required this.url});

  @override
  State<_BannerVideoPlayer> createState() => _BannerVideoPlayerState();
}

class _BannerVideoPlayerState extends State<_BannerVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
          _controller.setLooping(true);
          _controller.setVolume(0);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: _controller.value.isInitialized
          ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}