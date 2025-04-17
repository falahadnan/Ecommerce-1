import 'package:flutter/material.dart';
import '../services/skaidev_api_service.dart';

class GalleryScreen extends StatefulWidget {
  final String token;
  const GalleryScreen({super.key, required this.token});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late SkaidevApiService _apiService;
  late Future<List<String>> _galleryUrls;

  @override
  void initState() {
    super.initState();
    _apiService = SkaidevApiService(token: widget.token);
    _galleryUrls = _apiService.fetchGalleryUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galerie')),
      body: FutureBuilder<List<String>>(
        future: _galleryUrls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Erreur: ${snapshot.error}'));

          final urls = snapshot.data ?? [];
          return GridView.builder(
            itemCount: urls.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final url = urls[index];
              final isVideo = url.endsWith('.mp4') || url.contains('video');
              return Card(
                child: isVideo
                    ? Center(child: Icon(Icons.videocam, size: 40))
                    : Image.network(url, fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
