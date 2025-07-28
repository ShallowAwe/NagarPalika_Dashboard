
import 'package:riverpod/riverpod.dart';
   
import 'package:smart_nagarpalika_dashboard/model/employee_model.dart';
import 'package:smart_nagarpalika_dashboard/services/employee_services.dart';

/// Riverpod provider for managing and caching employees.
/// This is tied to [EmployeeNotifier], which handles fetching logic.
final employeeProvider =
    AsyncNotifierProvider<EmployeeNotifier, List<Employee>>(EmployeeNotifier.new);
