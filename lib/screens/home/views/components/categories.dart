import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Ensure this path is correct for your ProductsByCategoryScreen
// import 'package:shop/screens/products_by_category_screen.dart';
// No Dio or FlutterSecureStorage needed directly here if using CategoriesService
import 'package:flutter/foundation.dart'; // For kDebugMode
// Import your CategoriesService
import 'package:shop/services/categories_service.dart'; // Adjust path if needed
// Ensure constants like defaultPadding and primaryColor are imported
import '../../../../constants.dart';


// === YOUR ACTUAL CATEGORY MODEL (as you provided) === //
class Category {
  final int id;
  final String name;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String? finalImageUrl;
    String? thumb = json['thumbnail_image']?.toString();
    String? img = json['image']?.toString();

    if (thumb != null && thumb.isNotEmpty) {
      if (thumb.startsWith('http')) {
        finalImageUrl = thumb;
      } else {
        finalImageUrl = 'https://admin.skaidev.com/$thumb';
      }
    } else if (img != null && img.isNotEmpty) {
      if (img.startsWith('http')) {
        finalImageUrl = img;
      } else {
        finalImageUrl = 'https://admin.skaidev.com/$img';
      }
    }

    return Category(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unnamed Category',
      imageUrl: finalImageUrl,
    );
  }
}

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late Future<List<Category>> _categoriesFuture;
  // No _dio instance needed here if using CategoriesService

  @override
  void initState() {
    super.initState();
    if (kDebugMode) print("CategoriesWidget: initState (Using CategoriesService)");
    _categoriesFuture = _fetchCategoriesAndHandleRetries();
  }

  Future<List<Category>> _fetchCategoriesAndHandleRetries({int retries = 1}) async { // Reduced retries
    for (var i = 0; i < retries; i++) {
      try {
        return await _fetchCategoriesFromApiService(); // Call the method using CategoriesService
      } catch (e) {
        if (kDebugMode) print("CategoriesWidget: Attempt ${i + 1} to fetch via service failed. Error: $e");
        if (i == retries - 1) {
          if (kDebugMode) print("CategoriesWidget: All retries failed. Rethrowing last error.");
          rethrow;
        }
        // Only retry for specific network-like DioErrors, otherwise rethrow
        if (e is DioError &&
            (e.type == DioErrorType.connectionTimeout ||
             e.type == DioErrorType.sendTimeout ||
             e.type == DioErrorType.receiveTimeout ||
             e.type == DioErrorType.unknown)) {
          await Future.delayed(const Duration(seconds: 2));
        } else {
          rethrow; // Rethrow other DioErrors (like 401, 404) or general Exceptions immediately
        }
      }
    }
    throw Exception('Échec du chargement des catégories après $retries tentatives (should not be reached).');
  }

// In your _CategoriesWidgetState (inside the file for CategoriesWidget)
// Method: _fetchCategoriesFromApiService

  Future<List<Category>> _fetchCategoriesFromApiService() async {
      if (kDebugMode) print("CategoriesWidget: Fetching categories via CategoriesService (page 1).");

      final Map<String, dynamic> responseData = await CategoriesService.fetchCategoriesFromApi(page: 1);

      if (kDebugMode) {
        print("CategoriesWidget: Response Data from CategoriesService: $responseData");
      }

      List<dynamic> categoryListFromApi = [];
      if (responseData['entities'] != null && responseData['entities'] is List) { // <<<--- CHANGED 'message' to 'entities'
        categoryListFromApi = responseData['entities'];
        if (kDebugMode) print("CategoriesWidget: Found categories in responseData['entities']");
      } else {
        if (kDebugMode) print("CategoriesWidget: 'entities' key not found or not a list. Keys in response: ${responseData.keys}");
      }
      
      if (categoryListFromApi.isEmpty && responseData.isNotEmpty) {
          if (kDebugMode) print("CategoriesWidget: Parsed category list from API ('entities' key) is empty.");
      }
      
      return categoryListFromApi.map((jsonItem) {
        try {
          return Category.fromJson(jsonItem as Map<String, dynamic>);
        } catch (e,s) {
          if (kDebugMode) {
            print("CategoriesWidget: Error parsing single category item: $jsonItem, error: $e, stack: $s");
          }
          return null; 
        }
      }).whereType<Category>().toList();
  }

  Future<void> _refreshCategories() async {
    if (kDebugMode) print("CategoriesWidget: Refresh triggered.");
    setState(() {
      _categoriesFuture = _fetchCategoriesAndHandleRetries();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print("CategoriesWidget: build method called.");
    return RefreshIndicator(
      onRefresh: _refreshCategories,
      child: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (kDebugMode) print("CategoriesWidget FutureBuilder: ConnectionState: ${snapshot.connectionState}, HasError: ${snapshot.hasError}, HasData: ${snapshot.hasData}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(context, snapshot.error.toString());
          }

          final categories = snapshot.data;
          if (categories == null || categories.isEmpty) {
            return _buildEmptyWidget(context);
          }

          return _buildCategoriesList(context, categories);
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.contains('host lookup') || error.contains('SocketException')
                  ? 'Serveur indisponible. Vérifiez votre connexion internet.'
                  : error.replaceFirst("Exception: ", ""),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshCategories,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          const Text('Aucune catégorie disponible', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, List<Category> categories) {
    return SizedBox(
      height: 120, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: CategoryButton(
              category: categories[index],
              // isActive: false, // Manage active state if needed
            ),
          );
        }
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final Category category;
  final bool isActive;

  const CategoryButton({
    super.key,
    required this.category,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = category.imageUrl;
    final bool isSvg = imageUrl?.toLowerCase().endsWith('.svg') ?? false;
    final bool hasValidImage = imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http');

    return InkWell(
      onTap: () {
        if (kDebugMode) print("CategoryButton: Tapped on ${category.name}, ID: ${category.id}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsByCategoryScreen(
              categoryId: category.id,
              categoryName: category.name,
              categoryImageUrl: category.imageUrl,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: isActive ? primaryColor.withOpacity(0.2) : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? primaryColor : Theme.of(context).dividerColor.withOpacity(0.5),
                  width: isActive ? 2 : 1,
                )
              ),
              clipBehavior: Clip.antiAlias,
              child: hasValidImage
                  ? (isSvg
                      ? SvgPicture.network(
                          imageUrl!,
                          fit: BoxFit.contain,
                          placeholderBuilder: (_) => const Padding(padding: EdgeInsets.all(10.0), child: CircularProgressIndicator(strokeWidth: 2)),
                          colorFilter: ColorFilter.mode(
                            isActive
                                ? primaryColor
                                : Theme.of(context).iconTheme.color ?? Colors.black,
                            BlendMode.srcIn,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Padding(padding: EdgeInsets.all(10.0), child: CircularProgressIndicator(strokeWidth: 2)),
                          errorWidget: (context, url, error) => Icon(Icons.category_outlined, size: 30, color: Theme.of(context).disabledColor),
                        ))
                  : Icon(Icons.category, size: 30, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? primaryColor
                    : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for ProductsByCategoryScreen
class ProductsByCategoryScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final String? categoryImageUrl;

  const ProductsByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.categoryImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (categoryImageUrl != null && categoryImageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  categoryImageUrl!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.category, size: 60),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              "ID: $categoryId",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Nom: $categoryName",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              "Texte de la catégorie : $categoryName",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
           
            // Ici tu peux ajouter le FutureBuilder pour afficher les produits de la catégorie
          ],
        ),
      ),
    );
  }
}

// Your CategoriesService.dart file (ensure this is in lib/services/categories_service.dart or adjust import)
// You already provided this, so make sure it's in the correct location.
/*
// lib/services/categories_service.dart
import 'package:shop/services/api_client.dart';
import 'package:flutter/foundation.dart';

class CategoriesService {
  static Future<Map<String, dynamic>> fetchCategoriesFromApi({required int page}) async {
    final String path = '/fetch-categories'; // Or '/categories' - VERIFY THIS
    if (kDebugMode) {
      print("CategoriesService: Calling ApiClient.get for path: $path with page: $page");
    }
    try {
      final response = await ApiClient.get(
        path,
        queryParameters: {'page': page},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        if (kDebugMode) print("CategoriesService: Unexpected response data type: ${response.data.runtimeType}");
        throw Exception("Failed to load categories: Unexpected server response format.");
      }
    } catch (e) {
      if (kDebugMode) print("CategoriesService: Error fetching categories: $e");
      rethrow;
    }
  }
}
*/