// providers/complaint_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smart_nagarpalika_dashboard/model/compllaints_model.dart';
import 'package:smart_nagarpalika_dashboard/services/complaint_service.dart';

final complaintServiceProvider = Provider((ref) => ComplaintService());

final complaintsProvider = FutureProvider<List<ComplaintModel>>((ref) async {
  final service = ref.read(complaintServiceProvider);
  return await service.fetchAllComplaints();
});
