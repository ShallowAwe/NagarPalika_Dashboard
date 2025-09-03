import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:smart_nagarpalika_dashboard/model/alert_model.dart';
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class AlertService {
  final String baseUrl = "http://localhost:8080/admin";

  /// Create new alert
  Future<String> createAlert({
    required String title,
    required String description,
    Uint8List? imageBytes,
    required String type,
    String? imageName,
  }) async {
    final uri = Uri.parse("$baseUrl/create_alert");
    var request = http.MultipartRequest("POST", uri);

    // Add authentication headers
    request.headers.addAll(getAuthHeaders());

    // Required text fields
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['type'] = type;


    // Optional image
    if (imageBytes != null && imageName != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: imageName,
      ));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception(
        "Failed to create alert: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  }

  /// Get all alerts
  Future<List<AlertModel>> getAllAlerts() async {
    final response = await authorizedGet('/get_all_alerts');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AlertModel.fromJson(e)).toList();
    } else if (response.statusCode == 204) {
      // NO_CONTENT
      return [];
    } else {
      throw Exception(
        "Failed to fetch alerts: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  }

  /// Delete alert by ID
  Future<String> deleteAlert(String id) async {
    final uri = Uri.parse("$baseUrl/$id");
    final response = await http.delete(
      uri,
      headers: getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        "Failed to delete alert: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  }
}
