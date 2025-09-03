import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/model/alert_model.dart';
import 'package:smart_nagarpalika_dashboard/services/alert_service.dart';

// Service provider
final alertServiceProvider = Provider((ref) => AlertService());

// FutureProvider for fetching all alerts
final alertsProvider = FutureProvider<List<AlertModel>>((ref) async {
  final service = ref.read(alertServiceProvider);
  return await service.getAllAlerts();
});
