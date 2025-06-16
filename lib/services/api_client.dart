// lib/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// No FlutterSecureStorage import needed here directly
import '../token_manager.dart'; // Import TokenManager (adjust path if needed, e.g. 'token_manager.dart' if in same folder)

class ApiClient {
  // This _dio is NOT USED by your get/post methods below in this specific version.
  // If you later refactor to use a single Dio instance with interceptors, this will be important.
  static final Dio _unusedDioInstance = Dio(BaseOptions(
    baseUrl: 'https://admine.skandev.com', // Example, not used by current get/post
    connectTimeout: const Duration(seconds: 30),
  ));

  // This baseUrl is NOT USED by your get/post methods below.
  // final String baseUrlForReferenceOnly = 'http://10.0.2.2:8000';


  // No static _storage instance needed here

  static Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters, Map<String, String>? body /* body in GET is non-standard */}) async {
    final token = TokenManager().currentToken; // *** GET TOKEN FROM TokenManager ***
    final dio = Dio(); // Creates a new Dio instance for each call (as per your current working version)

    Map<String, String> requestHeaders = { // Use Map<String,String> for headers
      'Accept': 'application/json',
    };

    if (path.toLowerCase() != "/login" && token != null && token.isNotEmpty) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      print("--- ApiClient GET (Using TokenManager) ---");
      print("Path: $path");
      print("Target URL: https://admin.skaidev.com/api$path"); // Hardcoded URL
      print("Token from TokenManager: $token");
      print("Headers being sent: $requestHeaders");
      if (queryParameters != null) print("Query Params: $queryParameters");
      if (body != null) print("Body (for GET, unusual): $body");
    }

    try {
      var response = await dio.get( // Changed from dio.request to dio.get for clarity
        'https://admin.skaidev.com/api$path', // ALWAYS HITS DEPLOYED
        queryParameters: queryParameters,
        options: Options(
          method: 'GET', // Explicitly GET, though dio.get implies it
          headers: requestHeaders,
        ),
        // data: body, // If GET truly needs a body (non-standard)
      );
      if (kDebugMode) {
        print("Response Status for GET $path: ${response.statusCode}");
      }
      return response;
    } on DioError catch (e) {
      if (kDebugMode) {
        print("ApiClient: DioError on GET $path: ${e.message}");
        if (e.response != null) {
          print("ApiClient: Error Response Status: ${e.response?.statusCode}");
          print("ApiClient: Error Response Data: ${e.response?.data}");
        } else {
          print("ApiClient: DioError type: ${e.type}");
        }
      }
      rethrow;
    } finally {
      dio.close();
    }
  }

  static Future<Response> post(String path, dynamic data, {Map<String, dynamic>? queryParameters}) async {
    final token = TokenManager().currentToken; // *** GET TOKEN FROM TokenManager ***
    final dio = Dio(); // Creates a new Dio instance for each call

    Map<String, String> requestHeaders = { // Use Map<String,String> for headers
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (path.toLowerCase() != "/login" && token != null && token.isNotEmpty) {
      requestHeaders['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      print("--- ApiClient POST (Using TokenManager) ---");
      print("Path: $path");
      print("Target URL: https://admin.skaidev.com/api$path"); // Hardcoded URL
      print("Token from TokenManager: $token");
      print("Headers being sent: $requestHeaders");
      if (data != null) print("Data being sent: $data");
      if (queryParameters != null) print("Query Params: $queryParameters");
    }

    try {
      var response = await dio.post( // Changed from dio.request to dio.post for clarity
        'https://admin.skaidev.com/api$path', // ALWAYS HITS DEPLOYED
        data: data,
        queryParameters: queryParameters,
        options: Options(
            method: 'POST', // Explicitly POST
            headers: requestHeaders,
        ),
      );
      if (kDebugMode) {
        print("Response Status for POST $path: ${response.statusCode}");
      }
      return response;
    } on DioError catch (e) {
      if (kDebugMode) {
        print("ApiClient: DioError on POST $path: ${e.message}");
        if (e.response != null) {
          print("ApiClient: Error Response Status: ${e.response?.statusCode}");
          print("ApiClient: Error Response Data: ${e.response?.data}");
        } else {
          print("ApiClient: DioError type: ${e.type}");
        }
      }
      rethrow;
    } finally {
      dio.close();
    }
  }
}