import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';
import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:http/http.dart' as http;
import 'package:smart_nagarpalika_dashboard/services/service_base.dart';

class DetailsPopup extends StatefulWidget {
  final Employee employee;

  const DetailsPopup({super.key, required this.employee});

  @override
  State<DetailsPopup> createState() => _DetailsPopupState();
}

class _DetailsPopupState extends State<DetailsPopup> {
  List<ComplaintModel> _complaints = [];
  bool _isLoadingComplaints = true;
  String? _complaintsError;
  
  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    try {
      setState(() {
        _isLoadingComplaints = true;
        _complaintsError = null;
      });
      
      final complaints = await _fetchAllAsignedComplaints();
      setState(() {
        _complaints = complaints;
        _isLoadingComplaints = false;
      });
    } catch (e) {
      setState(() {
        _complaintsError = e.toString();
        _isLoadingComplaints = false;
      });
    }
  }

  Future<List<ComplaintModel>> _fetchAllAsignedComplaints() async {
    final _username = 'admin';
    final _password = 'admin';
    final String basicAuth =
      'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';
    final employee = widget.employee;
    final url = Uri.parse('http://localhost:8080/admin/assignedComplaint/${employee.firstName}');
    
    Logger().i('Fetching assigned complaints for employee: ${employee.firstName}');
    Logger().i('API URL: $url');
    Logger().i('Authorization header: $basicAuth');
    
    try {
      final response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        }
      );

      Logger().i('Response status code: ${response.statusCode}');
      Logger().i('Response headers: ${response.headers}');
      Logger().i('Response body length: ${response.body.length}');
      Logger().i('Response body content: "${response.body}"');
      
      // Check if response body is empty or just whitespace
      if (response.body.trim().isEmpty) {
        Logger().w('Response body is empty or contains only whitespace');
        return [];
      }

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          Logger().i('Successfully decoded JSON response. Response structure: ${jsonResponse.keys.toList()}');
          
          // Check if the response has the expected structure
          if (!jsonResponse.containsKey('data')) {
            Logger().e('Response missing data field. Response: $jsonResponse');
            throw Exception('Invalid response format: missing data field');
          }
          
          final List<dynamic> data = jsonResponse['data'];
          Logger().i('Parsed JSON data: ${data.length} items');
          
          if (data.isEmpty) {
            Logger().i('Data array is empty - no complaints found');
            return [];
          }
          
          final complaints = data
              .map((json) {
                Logger().d('Processing complaint JSON: $json');
                return ComplaintModel.fromJson(json);
              })
              .toList();
          
          Logger().i('Successfully parsed ${complaints.length} complaints for employee ${employee.firstName}');
          Logger().i('Response message: ${jsonResponse['message']}');
          Logger().i('Total count: ${jsonResponse['count']}');
          return complaints;
          
        } catch (jsonError) {
          Logger().e('JSON parsing error: $jsonError');
          Logger().e('Raw response body: "${response.body}"');
          throw Exception('Invalid JSON response from server: $jsonError');
        }
        
      } else if (response.statusCode == 204) {
        Logger().w('No complaints found - HTTP 204 response');
        return []; // No complaints
        
      } else if (response.statusCode == 401) {
        Logger().e('Authentication failed - HTTP 401');
        throw Exception('Authentication failed. Please check credentials.');
        
      } else if (response.statusCode == 404) {
        Logger().w('Employee not found - HTTP 404');
        return []; // Employee not found
        
      } else {
        Logger().e('Failed to fetch complaints: HTTP ${response.statusCode}');
        Logger().e('Response body: "${response.body}"');
        throw Exception('Failed to fetch complaints: HTTP ${response.statusCode}');
      }
      
    } catch (e) {
      Logger().e('Exception occurred while fetching complaints: $e');
      if (e is FormatException) {
        Logger().e('JSON parsing error: $e');
        throw Exception('Invalid response format from server');
      } else if (e.toString().contains('SocketException')) {
        Logger().e('Network connection error: $e');
        throw Exception('Unable to connect to server. Please check your internet connection.');
      } else {
        throw Exception('Error fetching complaints: $e');
      }
    }
  }
  
    @override
  Widget build(BuildContext context) {
    final employee = widget.employee;  
    return Center(
    child: Card(
      elevation: 16,
       color: Colors.white,
       shadowColor: Colors.blueAccent.withAlpha(21),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
       child: Container(
        width: 650,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
       child: Stack(
        children: [
          Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
             tooltip: 'close',
             ), 
          ),
          SingleChildScrollView(
            child: Column( 
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Employee Details',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                        color: Color(0xFF397DE1),
                        letterSpacing: 0.5,
                  ),
                ),
                    const SizedBox(height: 4),
                Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                        color: const Color(0xFF397DE1).withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                ),
                const Divider(
                   height: 1,
                   thickness: 1,
                      color: Color(0xFFE3E8F0),
                    ),
                    const SizedBox(height: 16),
            
                    // Header row with avatar and basic info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            employee.firstName.isNotEmpty
                                ? employee.firstName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(221, 26, 20, 20),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _pill('ID ${employee.id}'),
                                  const SizedBox(width: 8),
                                  _pill(employee.department),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 20),
            
                    // Details grid
                    _detailSection(
                      title: 'Contact Information',
                      children: [
                        _detailRow('Phone', employee.contactInfo.isEmpty ? '-' : employee.contactInfo),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _detailSection(
                      title: 'Wards',
                      children: [
                        if (employee.wardsName.isEmpty)
                          const Text('-', style: TextStyle(color: Colors.black87))
                        else
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: employee.wardsName
                                .map((w) => Chip(
                                      label: Text(w),
                                      backgroundColor: Colors.grey.shade100,
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    _detailSection(
                      title: 'Assigned Complaints',
                      children: [
                        if (_isLoadingComplaints)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (_complaintsError != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Error loading complaints: $_complaintsError',
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        else if (_complaints.isEmpty)
                          const Text('No complaints assigned', style: TextStyle(color: Colors.black87))
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _complaints
                                .map((c) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.bug_report, size: 16, color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  c.description.isNotEmpty ? c.description : 'No Description',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Status: ${c.status}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  'Location: ${c.location}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ],
                ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color.fromARGB(255, 52, 140, 228),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _detailSection({
  required String title,
  required List<Widget> children,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE3E8F0)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(25),
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        /// 👇 scrollable + constrained section
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300, // adjust as per your UI
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}