import 'package:flutter/material.dart';

class AdminSidebar extends StatefulWidget {
  @override
  _AdminSidebarState createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  bool isExpanded = true; // State to track if the sidebar is expanded

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
                isExpanded ? Icons.arrow_back_ios_new_sharp : Icons.arrow_forward_ios_sharp,
                size: 20,
              ),
            ),
          ),
          SidebarItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            isExpanded: isExpanded,
            onTap: () {
              // Navigate to Dashboard
            },
          ),
          SidebarItem(
            icon: Icons.book,
            title: 'Manage Books',
            isExpanded: isExpanded,
            onTap: () {
              // Navigate to Manage Books
            },
          ),
          SidebarItem(
            icon: Icons.shopping_cart,
            title: 'View Orders',
            isExpanded: isExpanded,
            onTap: () {
              // Navigate to View Orders
            },
          ),
          SidebarItem(
            icon: Icons.people,
            title: 'Manage Users',
            isExpanded: isExpanded,
            onTap: () {
              // Navigate to Manage Users
            },
          ),
          SidebarItem(
            icon: Icons.settings,
            title: 'Settings',
            isExpanded: isExpanded,
            onTap: () {
              // Navigate to Settings
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
