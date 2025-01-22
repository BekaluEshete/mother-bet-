import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mother/admins_screen/dashboard.dart';
import 'package:mother/admins_screen/manage-user.dart';
import 'package:mother/admins_screen/manage-menu-items.dart';
import 'package:mother/admins_screen/sale-report.dart';
import 'package:mother/auth/login.dart';
import 'package:mother/navigation/edit.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  SidebarState createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    // Function for login dialog
    Future<void> _logout() async {
      // Show a confirmation  logging out
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Log Out"),
            content: const Text("Are you sure you want to log out?"),
            actions: <Widget>[
              // Cancel 
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // Logout Button
              TextButton(
                child: const Text("Log Out"),
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop(); // Close the dialog  
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout failed: ${e.toString()}')),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Drawer(
      width: _isCollapsed ? 70 : (isSmallScreen ? screenWidth * 0.6 : 250),
      child: Container(
        color: const Color(0xFF2A2D3E),
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: _isCollapsed ? 8 : 20, vertical: 30),
              alignment: Alignment.centerLeft,
              color: const Color(0xFF1F212E),
              child: Row(
                children: [
                  if (!_isCollapsed)
                    const Expanded(
                      child: Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      _isCollapsed
                          ? Icons.arrow_forward_ios
                          : Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DashboardScreen(),
                        ));
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.food_bank_outlined,
                      title: 'Manage Menu Items',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MenuManagementScreen(),
                        ));
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.manage_accounts,
                      title: 'Manage Users',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ManageUsersScreen(),
                        ));
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.bar_chart,
                      title: 'Sales Reports',
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SaleReport(),
                        ));
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EditScreen(),
                        ));
                      },
                    ),
                    const Divider(color: Colors.white38),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: _logout, // Call logout method with dialog
                    ),
                  ],
                ),
              ),
            ),

            // Footer Section
            if (!_isCollapsed)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '© 2025 Admin Dashboard by Mother-bet',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Menu Item Builder
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      title: !_isCollapsed
          ? Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: const Color(0xFF1F212E),
    );
  }
}
