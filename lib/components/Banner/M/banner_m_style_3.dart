import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
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

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
        url: json['url'],
        type: json['type'],
        title: json['title'],
        discountParcent: json['discountParcent'],
      );
}

class BannerMStyle3 extends StatefulWidget {
  const BannerMStyle3(
      {super.key,
      required String title,
      required int discountParcent,
      required Null Function() press});

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

  Future<List<BannerItem>> fetchBanners() async {
    final response = await Dio().get(
        'https://test666.skaidev.com/api/mes-images'); // <-- Mets ici ton API
    if (response.statusCode == 200) {
      final List bannersJson = (response.data['data'] as List);
      return bannersJson.map((json) => BannerItem.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des bannières');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerItem>>(
        future: _bannersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // On tente de charger dynamiquement toutes les images de l'API d'images
            return FutureBuilder<Response>(
              future: Dio().get('https://test666.skaidev.com/api/mes-images'),
              builder: (context, imgSnapshot) {
                if (imgSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (imgSnapshot.hasError) {
                  // Si même l'API d'image échoue, on affiche un message d'erreur simple
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Erreur lors du chargement des images de secours.\n\n${imgSnapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  );
                }
                try {
                  final List images = (imgSnapshot.data?.data['data'] as List);
                  if (images.isNotEmpty) {
                    // Affiche la première image de l'API de secours
                    return Center(
                      child: Image.network(
                        images[0]['url'],
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image,
                                size: 60, color: Colors.grey),
                      ),
                    );
                  }
                } catch (_) {}
                // Si pas d'image trouvée, fallback texte
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Aucune image trouvée dans l’API de secours.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              },
            );
          }
          final banners = snapshot.data ?? [];
          if (banners.isEmpty) {
            return const Center(child: Text('Aucune bannière trouvée.'));
          }
          return SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index]; // index est bien un int ici
                  return BannerM(
                    image: banner.type == 'image' ? banner.url : '',
                    press: () {},
                    children: [
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
                                      fontFamily: grandisExtendedFont,
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
                      if (banner.type == 'video')
                        _BannerVideoPlayer(url: banner.url),
                    ],
                  );
                },
              ));
        });
  }
}

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
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
