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
        // Complaint images section (all images with gallery)
        if (complaint.imageUrls.isNotEmpty) ...[
          _buildDetailCard('Complaint Images', Icons.photo_library, [
            _buildImageGrid(complaint.imageUrls, basicAuth, 'Complaint Images'),
          ]),
          const SizedBox(height: 16),
        ],

        // Complaint details with enhanced styling
        _buildDetailCard('Complaint Information', Icons.info_outline, [
          _buildDetailRow('ID', '#${complaint.id}'),
          _buildDetailRow('Department', complaint.departmentName),
          if (complaint.wardName != null)
            _buildDetailRow('Ward', complaint.wardName!),
          _buildDetailRow('Location', complaint.location),
          _buildDetailRow('Status', complaint.status),
          _buildDetailRow('Submitted by', complaint.submittedBy),
          _buildDetailRow('Created', _formatDate(complaint.createdAt)),
          if (complaint.completedAt != null)
            _buildDetailRow('Completed', _formatDate(complaint.completedAt!)),
        ]),
        const SizedBox(height: 16),
        _buildDetailCard('Description', Icons.description, [
          _buildDetailRow(
            'Details',
            complaint.description,
            isDescription: true,
          ),
        ]),

        // Employee updates section
        if ((complaint.employeeRemark != null &&
                complaint.employeeRemark!.trim().isNotEmpty) ||
            complaint.employeeImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildDetailCard('Employee Updates', Icons.engineering, [
            if (complaint.employeeRemark != null &&
                complaint.employeeRemark!.trim().isNotEmpty)
              _buildDetailRow('Remark', complaint.employeeRemark!,
                  isDescription: true),
            if (complaint.employeeImages.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildImageGrid(
                  complaint.employeeImages, basicAuth, 'Employee Images'),
            ],
          ]),
        ],
      ],
    );
  }

  // _buildImagePreview removed (unused)

  Widget _buildImageGrid(
      List<String> imageUrls, String basicAuth, String galleryTitle) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        final url = imageUrls[index];
        return InkWell(
          onTap: () => _openGallery(context, imageUrls, index, basicAuth,
              title: galleryTitle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  url,
                  headers: {'Authorization': basicAuth},
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${index + 1}/${imageUrls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openGallery(BuildContext context, List<String> imageUrls, int index,
      String basicAuth, {String? title}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImageGalleryPage(
          imageUrls: imageUrls,
          initialIndex: index,
          basicAuth: basicAuth,
          title: title,
        ),
        fullscreenDialog: true,
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

class _ImageGalleryPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String basicAuth;
  final String? title;

  const _ImageGalleryPage({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
    required this.basicAuth,
    this.title,
  }) : super(key: key);

  @override
  State<_ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<_ImageGalleryPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title ?? 'Gallery'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              final url = widget.imageUrls[index];
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: Image.network(
                    url,
                    headers: {'Authorization': widget.basicAuth},
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.broken_image, size: 64, color: Colors.white70),
                        SizedBox(height: 8),
                        Text('Failed to load image',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.imageUrls.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
