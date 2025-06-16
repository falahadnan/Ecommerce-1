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