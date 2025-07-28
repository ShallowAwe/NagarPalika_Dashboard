// services/complaint_service.dart

import 'dart:convert';

import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class ComplaintService {
  /// Fetch all complaints using Basic Auth
  Future<List<ComplaintModel>> fetchAllComplaints() async {
    final response = await authorizedGet('/all_complaints');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final complaints = data
          .map((json) => ComplaintModel.fromJson(json))
          .toList();
      print('Fetched complaints: ' + complaints.toString()); // Debug print
      return complaints;
    } else if (response.statusCode == 204) {
      return []; // No complaints
    } else {
      throw Exception('Failed to fetch complaints: ${response.statusCode}');
    }
  }
}
