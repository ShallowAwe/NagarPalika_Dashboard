import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nagarpalika_dashboard/screens/complaint_management_page.dart';
import 'package:smart_nagarpalika_dashboard/screens/department_page.dart';
import 'package:smart_nagarpalika_dashboard/screens/employee_management_page.dart';
// import 'package:smart_nagarpalika_dashboard/screens/employee_management_page.dart';
import 'package:smart_nagarpalika_dashboard/screens/login_page.dart';
import 'package:smart_nagarpalika_dashboard/screens/overviewpage.dart';
import 'package:smart_nagarpalika_dashboard/screens/user_management_page.dart';
import 'package:smart_nagarpalika_dashboard/utils/sideBar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: AdminDashboardApp()));
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Admin Dashboard',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginPage(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  final String username;
  const AdminDashboard({super.key, required this.username});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  final List<String> navItems = [
    'Dashboard',
    'Users',
    'Complaints',
    'Employees',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: Text('Admin Dashboard'),
      //   // backgroundColor: Colors.blueAccent,
      // ),
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: 250,
            child: Sidebar(
              username: widget.username,
              selectedIndex: selectedIndex,
              onItemSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: getMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMainContent() {
    switch (selectedIndex) {
      case 0:
        return Overviewpage();
      case 1:
        return Usermanagementscreen();
      case 2:
        return ComplaintManagementPage();
      case 3:
        return EmployeeManagementPage();
      case 4:
        return DepartmentPage();
      case 5:
        return Center(child: Text("Alerts"));
      default:
        return Center(child: Text("Select a tab"));
    }
  }
}
