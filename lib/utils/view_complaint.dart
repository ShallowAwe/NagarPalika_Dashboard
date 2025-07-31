import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';

class ViewComplaint extends StatelessWidget {
  final List<ComplaintModel> complaints;

  const ViewComplaint({Key? key, required this.complaints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = 'user1';
    final password = 'user1';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    // Early return if no complaints
    if (complaints.isEmpty) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const SizedBox(
          width: 400,
          height: 200,
          child: Center(child: Text('No complaints to display')),
        ),
      );
    }

    final complaint = complaints[0]; // Cache the first complaint

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient background
            _buildHeader(context),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Details
                    Expanded(
                      flex: 2,
                      child: _buildLeftColumn(complaint, basicAuth),
                    ),
                    const SizedBox(width: 24),

                    // Right Column - Resolution Status
                    Expanded(child: _buildRightColumn(context, complaint)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.report_problem,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Complaint Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(ComplaintModel complaint, String basicAuth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image preview with enhanced styling
        if (complaint.imageUrls.isNotEmpty) ...[
          _buildImagePreview(complaint.imageUrls[0], basicAuth),
          const SizedBox(height: 24),
        ],

        // Complaint details with enhanced styling
        _buildDetailCard('Complaint Information', Icons.info_outline, [
          _buildDetailRow('ID', '#${complaint.id}'),
          _buildDetailRow('Department', complaint.departmentName),
          _buildDetailRow('Location', complaint.location),
          _buildDetailRow('Status', complaint.status),
          _buildDetailRow('Submitted by', complaint.submittedBy),
          _buildDetailRow('Created', _formatDate(complaint.createdAt)),
        ]),
        const SizedBox(height: 16),
        _buildDetailCard('Description', Icons.description, [
          _buildDetailRow(
            'Details',
            complaint.description,
            isDescription: true,
          ),
        ]),
      ],
    );
  }

  Widget _buildImagePreview(String imageUrl, String basicAuth) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(30),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          headers: {'Authorization': basicAuth},
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Image not available',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, ComplaintModel complaint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Resolution Status Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.assignment_turned_in, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Resolution Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Employee Assignment Status
        _buildStatusCard(
          'Assigned Employee',
          Icons.person,
          complaint.assignedEmployeeName ?? 'Not assigned',
          Colors.blue,
        ),
        const SizedBox(height: 16),

        // Resolution Status
        _buildStatusCard(
          'Current Status',
          complaint.status == 'Resolved' ? Icons.check_circle : Icons.pending,
          complaint.status,
          complaint.status == 'Resolved' ? Colors.green : Colors.orange,
        ),

        // Action Buttons
        _buildActionButtons(context, complaint),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ComplaintModel complaint) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('Close'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (complaint.status != 'Resolved') ...[
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle mark as resolved
                  // You can add your resolution logic here
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark as Resolved'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isDescription = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isDescription ? 14 : 16,
              fontWeight: isDescription ? FontWeight.normal : FontWeight.w500,
              color: Colors.grey.shade800,
            ),
            maxLines: isDescription ? 4 : 1,
            overflow: isDescription ? TextOverflow.ellipsis : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    IconData icon,
    String value,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
