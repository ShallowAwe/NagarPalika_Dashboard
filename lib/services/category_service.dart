import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import '../model/category_model.dart';
import 'service_base.dart';

class CategoryService {
  static final Logger _logger = Logger();

  // Fetch all categories
  static Future<List<Categories>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/get/categories');
    final response = await http.get(uri, headers: getAuthHeaders());

    _logger.d('Category API - Status: ${response.statusCode}');
    _logger.d('Category API - Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Categories.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch categories: ${response.body}');
    }
  }

  // Create a new category - supports both File and Uint8List
  static Future<Categories> createCategory({
    required String name,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final uri = Uri.parse('$baseUrl/create_categories');

    final request = http.MultipartRequest('POST', uri);
    
    // Add auth headers to multipart request
    final authHeaders = getAuthHeaders();
    request.headers.addAll(authHeaders);

    // Add category data as JSON string with proper content type
    final categoryData = {
      "name": name,
    };
    
    // Use MultipartFile.fromString to set correct content type for JSON
    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(categoryData),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Add image - handle both File and Uint8List
    if (imageFile != null) {
      // For mobile/desktop - use File
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    } else if (imageBytes != null && imageName != null) {
      // For web - use bytes directly
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
        ),
      );
    }

    _logger.d('Creating category with data: ${jsonEncode(categoryData)}');
    
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logger.d('Create Category API - Status: ${response.statusCode}');
      _logger.d('Create Category API - Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Categories.fromJson(responseData);
      } else {
        throw Exception('Failed to create category: ${response.body}');
      }
    } catch (e) {
      _logger.e('Error creating category: $e');
      rethrow;
    }
  }

  // Update an existing category - supports both File and Uint8List
    static Future<Categories> updateCategory({
    required int id,
    required String name,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final uri = Uri.parse('$baseUrl/categories/$id');

    final request = http.MultipartRequest('PUT', uri);
    
    // Add auth headers to multipart request
    final authHeaders = getAuthHeaders();
    request.headers.addAll(authHeaders);

    // Add category data as JSON string
    final categoryData = {
      "name": name,
    };
    request.fields['data'] = jsonEncode(categoryData);

    // Add image - handle both File and Uint8List
    if (imageFile != null) {
      // For mobile/desktop - use File
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    } else if (imageBytes != null && imageName != null) {
      // For web - use bytes directly
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
        ),
      );
    }

    _logger.d('Updating category $id with data: ${jsonEncode(categoryData)}');

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logger.d('Update Category API - Status: ${response.statusCode}');
      _logger.d('Update Category API - Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Categories.fromJson(responseData);
      } else {
        throw Exception('Failed to update category: ${response.body}');
      }
    } catch (e) {
      _logger.e('Error updating category: $e');
      rethrow;
    }
  }

  // Delete a category
  static Future<void> deleteCategory(int id) async {
    final uri = Uri.parse('$baseUrl/categories/$id');
    final response = await http.delete(uri, headers: getAuthHeaders());

    _logger.d('Delete Category API - Status: ${response.statusCode}');
    _logger.d('Delete Category API - Body: ${response.body}');

    if (response.statusCode == 200) {
      _logger.i('Category deleted successfully');
    } else {
      throw Exception('Failed to delete category: ${response.body}');
    }
  }
}