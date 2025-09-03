import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:smart_nagarpalika_dashboard/model/wards_model.dart';
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class WardsServices {
   static final Logger  _logger = Logger();
  
  static Future<List<Wards>> fetchWards() async {
  final uri = Uri.parse("$baseUrl/get_wards");   // <-- use baseUrl, not base64Url
  final response = await http.get(uri, headers: getAuthHeaders());

  _logger.d('Wards API Response - Status: ${response.statusCode}');
  _logger.d('Wards API Response - Body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    final wards = data.map<Wards>((wrd) => Wards.fromJson(wrd)).toList();

    _logger.i('Fetched wards: ${wards.length} wards retrieved');
    return wards;
  } else {
    _logger.e('Failed to load wards: ${response.statusCode}');
    throw Exception("Failed to load wards");
  }
}

}