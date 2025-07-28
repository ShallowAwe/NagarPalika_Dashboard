  import 'dart:convert';
import 'package:http/http.dart' as http;

/// Shared base URL
const String baseUrl = 'http://localhost:8080/admin';

/// Shared admin credentials
const String _username = 'admin';
const String _password = 'admin';

/// Returns standard Basic Auth headers
Map<String, String> getAuthHeaders({Map<String, String>? extraHeaders}) {
  final String basicAuth =
      'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';

  return {
    'Content-Type': 'application/json',
    'Authorization': basicAuth,
    ...?extraHeaders,
  };
}

/// Optional reusable GET method
Future<http.Response> authorizedGet(String endpoint) {
  final uri = Uri.parse('$baseUrl$endpoint');
  return http.get(uri, headers: getAuthHeaders());
}

/// Optional reusable POST method
Future<http.Response> authorizedPost(String endpoint, Object body) {
  final uri = Uri.parse('$baseUrl$endpoint');
  return http.post(
    uri,
    headers: getAuthHeaders(),
    body: jsonEncode(body),
  );
}
