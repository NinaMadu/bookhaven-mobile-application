import 'package:bookshop/pages/admin/adminsettings.dart';
import 'package:bookshop/pages/admin/bookmanagement.dart';
import 'package:bookshop/pages/admin/dashboard.dart';
import 'package:bookshop/pages/admin/ordermanagement.dart';
import 'package:bookshop/pages/admin/usermanagement.dart';
import 'package:flutter/material.dart';

class AdminSidebar extends StatefulWidget {
  @override
  _AdminSidebarState createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  bool isExpanded = false; // State to track if the sidebar is expanded

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300), // Smooth animation
      width: isExpanded ? 200 : 70, // Adjust width based on state
      color: Colors.grey[200],
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // Toggle the expanded state
              });
            },
            child: DrawerHeader(
              child: Icon(
                isExpanded
                    ? Icons.arrow_back_ios_new_sharp
                    : Icons.arrow_forward_ios_sharp,
                size: 20,
              ),
            ),
          ),
          SidebarItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            isExpanded: isExpanded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDashboard(),
                ),
              );
            },
          ),
          SidebarItem(
            icon: Icons.book,
            title: 'Manage Books',
            isExpanded: isExpanded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookManagementPage(),
                ),
              );
            },
          ),
          SidebarItem(
            icon: Icons.shopping_cart,
            title: 'View Orders',
            isExpanded: isExpanded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderManagementPage(),
                ),
              );
            },
          ),
          SidebarItem(
            icon: Icons.people,
            title: 'Manage Users',
            isExpanded: isExpanded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserManagementPage(),
                ),
              );
            },
          ),
          SidebarItem(
            icon: Icons.settings,
            title: 'Settings',
            isExpanded: isExpanded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminsettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const SidebarItem({
    required this.icon,
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: isExpanded
          ? Text(
              title,
              style: TextStyle(fontSize: 16),
            )
          : null, // Show title only when expanded
      onTap: onTap,
    );
  }
}
