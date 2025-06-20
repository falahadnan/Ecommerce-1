import 'package:shop/models/product_model.dart';

import 'api_client.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProductService {
  static Future<Map<String, dynamic>> fetchAllProducts() async {
    try {
      final response = await ApiClient.get('/fetch-all-products', body: {});
      return response.data;
    } catch (e) {
      throw Exception('Failed to load products   :   $e');
    }
  }
}

// lib/services/products_service.dart

class ProductsService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://test666.skaidev.com/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  /// Récupère les produits d'une catégorie spécifique.
  /// L'API doit supporter un filtre comme `category_id`.
  static Future<Map<String, dynamic>> fetchProductsByCategory({
    required int categoryId,
    int page = 1,
  }) async {
    // Endpoint pour les produits. Adaptez si le nom est différent (ex: /get-products)
    const String productsEndpoint = '/products';

    try {
      if (kDebugMode) {
        print(
            "ProductsService: Appel de GET $productsEndpoint avec category_id=$categoryId");
      }

      final response = await _dio.get(
        productsEndpoint,
        queryParameters: {
          'category_id': categoryId, // C'est le paramètre clé pour filtrer !
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Échec du chargement des produits. Code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (kDebugMode) print("ProductsService: Erreur Dio -> ${e.message}");
      rethrow; // Propage l'erreur pour que l'UI puisse la gérer
    } catch (e) {
      if (kDebugMode) print("ProductsService: Erreur générique -> $e");
      rethrow;
    }
  }

  static Future<Product> fetchProductById(int productId) async {
    final String endpoint = '/products/$productId'; // <-- adapte ici

    try {
      final response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        return Product.fromJson(response.data);
      } else {
        throw Exception(
            'Échec du chargement du produit. Code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      if (kDebugMode) print("ProductsService: Erreur Dio -> ${e.message}");
      rethrow;
    } catch (e) {
      if (kDebugMode) print("ProductsService: Erreur générique -> $e");
      rethrow;
    }
  }
}


