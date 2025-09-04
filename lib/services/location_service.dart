import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../model/location_model.dart';
import 'service_base.dart';

class LocationService {
  static final Logger _logger = Logger();

  static Future<List<Location>> fetchLocations() async {
    final uri = Uri.parse('$baseUrl/locations');
    final response = await http.get(uri, headers: getAuthHeaders());

    _logger.d('Location API - Status: ${response.statusCode}');
    _logger.d('Location API - Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Location.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch locations');
    }
  }

  static Future<void> createLocation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int categoryId,
  }) async {
    final uri = Uri.parse('$baseUrl/create_locations');
    final body = {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'categoryId': categoryId,
    };

    final response = await http.post(
      uri,
      headers: getAuthHeaders(),
      body: jsonEncode(body),
    );

    _logger.d('Create Location - Status: ${response.statusCode}');
    _logger.d('Create Location - Body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create location');
    }
  }
}
