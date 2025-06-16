import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:shop/screens/category_detail_screen.dart';

// === Données mockées === //
class CategoryModel {
  final String id;
  final String name;
  final String url;
  final String slug;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.url,
    required this.slug,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'],
      url: json['url'],
      slug: json['slug'],
      image: json['image'],
    );
  }
}

class Categories {
  static Future<List<CategoryModel>> fetchAllCategories() async {
    await Future.delayed(const Duration(seconds: 1)); // Simuler délai réseau
    return [
      CategoryModel(
        id: '1',
        name: 'Électronique',
        url: 'https://example.com/electronique',
        slug: 'electronique',
        image: 'https://via.placeholder.com/150',
      ),
      CategoryModel(
        id: '2',
        name: 'Livres',
        url: 'https://example.com/livres',
        slug: 'livres',
        image: 'https://via.placeholder.com/150',
      ),
    ];
  }
}

// === UI === //
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<CategoryModel>> _categoriesFuture;
  final List<CategoryModel> _categories = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  String? get categoryProductsRoute => '/products'; // exemple

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<CategoryModel>> _fetchCategories() async {
    //if (_isLoading) return _categories;
    //setState(() => _isLoading = true);

    try {
      final List<CategoryModel> mockData =
          await Categories.fetchAllCategories();
      final newCategories = mockData;

      setState(() {
        _isLoading = false;
        _categories.addAll(newCategories);
        _hasMore = false; // désactiver pagination pour les mocks
      });

      return _categories;
    } catch (e) {
      setState(() => _isLoading = false);
      throw Exception('Failed to load categories: $e');
    }
  }

  void _loadMore() {
    if (_hasMore && !_isLoading) {
      setState(() {
        _currentPage++;
        _categoriesFuture = _fetchCategories();
      });
    }
  }

  String _getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    if (imagePath.startsWith('/public/storage'))
      return 'https://test34453.skaidev.com$imagePath';
    if (imagePath.startsWith('public/storage'))
      return 'https://test34453.skaidev.com/$imagePath';
    return 'https://test34453.skaidev.com${imagePath.startsWith('/') ? '' : '/'}$imagePath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _categories.clear();
                _currentPage = 1;
                _categoriesFuture = _fetchCategories();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load categories',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _categories.clear();
                        _currentPage = 1;
                        _categoriesFuture = _fetchCategories();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_categories.isEmpty) {
            return const Center(
                child: Text('No categories available',
                    style: TextStyle(fontSize: 16)));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: _categories.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _categories.length) {
                _loadMore();
                return const Center(child: CircularProgressIndicator());
              }

              final category = _categories[index];
              final imageUrl = _getFullImageUrl(category.image);

              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(
                          id: category.id,
                          name: category.name,
                          slug: category.slug,
                          imageUrl: _getFullImageUrl(category.image),
                        ),
                      ),
                    );
},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: Icon(Icons.image, color: Colors.grey)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
