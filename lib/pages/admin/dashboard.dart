import 'package:bookshop/pages/admin/ordermanagement.dart';
import 'package:bookshop/pages/admin/sidebar.dart';
import 'package:bookshop/pages/admin/usermanagement.dart';
import 'package:bookshop/pages/admin/bookmanagement.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AdminSidebar(),

          // Content Area
          Expanded(
            child: Column(
              children: [
                // Top Section with Image and Welcome Message
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Image
                      Image.asset(
                        'assets/icons/images/admin.png', // Correct asset path
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                          );
                        },
                      ),
                      // Welcome Message
                      Positioned(
                        bottom: 20,
                        child: Text(
                          'Welcome back, Admin!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 3, 9, 38),
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Action Buttons
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildActionButton(
                          icon: Icons.people,
                          label: 'Manage Users',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserManagementPage(),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.book_online_rounded,
                          label: 'Manage Books',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookManagementPage(),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.people,
                          label: 'Manage Orders',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderManagementPage(),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.settings,
                          label: 'Settings',
                          onTap: () {
                            // Navigate to Settings
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(20),
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
