import 'package:flutter/material.dart';
import 'package:smart_nagarpalika_dashboard/screens/overviewpage.dart';
import 'package:smart_nagarpalika_dashboard/screens/user_management_page.dart';
import 'package:smart_nagarpalika_dashboard/utils/sideBar.dart';

void main() => runApp(AdminDashboardApp());

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Admin Dashboard',s
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

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
              child: Sidebar(selectedIndex: selectedIndex,
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
        return Center(child: Text("📂 Complaints Section", style: TextStyle(fontSize: 24)));
      case 3:
        return Center(child: Text("🏢 Employee Management", style: TextStyle(fontSize: 24)));
      default:
        return Center(child: Text("Select a tab"));
    }
  }
}
