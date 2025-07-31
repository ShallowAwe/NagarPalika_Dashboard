// services/complaint_service.dart

import 'dart:convert';
import 'package:logger/logger.dart';

import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class ComplaintService {
  final Logger _logger = Logger();

  /// Fetch all complaints using Basic Auth
  Future<List<ComplaintModel>> fetchAllComplaints() async {
    final response = await authorizedGet('/all_complaints');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final complaints = data
          .map((json) => ComplaintModel.fromJson(json))
          .toList();
      _logger.i(
        'Fetched complaints: ${complaints.length} complaints retrieved',
      );
      return complaints;
    } else if (response.statusCode == 204) {
      _logger.w('No complaints found - empty response');
      return []; // No complaints
    } else {
      _logger.e('Failed to fetch complaints: ${response.statusCode}');
      throw Exception('Failed to fetch complaints: ${response.statusCode}');
    }
  }
}
