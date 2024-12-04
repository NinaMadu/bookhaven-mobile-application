import 'package:bookshop/pages/admin/adminaccountsettings.dart';
import 'package:bookshop/pages/admin/adminpasswordchange.dart';
import 'package:bookshop/pages/notifications.dart';
import 'package:bookshop/pages/supportpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AdminsettingsPage extends StatelessWidget {
  const AdminsettingsPage({super.key});

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser; // Get current user
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    // Check if the user is an admin
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Use the user's UID to fetch their details from 'users' collection
        .get();

    if (userDoc.exists) {
      // If user document exists, return user details
      return userDoc.data()!;
    } else {
      // If the user is not in 'users' collection, check in 'admin' collection
      final adminDoc = await FirebaseFirestore.instance
          .collection('admin')
          .doc(user.uid) // Use the user's UID to fetch their details from 'admin' collection
          .get();

      if (!adminDoc.exists) {
        throw Exception('User is not an admin and does not exist in either collection.');
      }

      return adminDoc.data()!; // Return admin details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No user data available.'));
          }

          final userData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            userData['avatar'] ??
                                'https://example.com/default-avatar.png',
                          ), // User profile image
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData['username'] ?? 'N/A', // Username
                          style: const TextStyle(
                            fontSize: 26,
                            color: Color.fromARGB(255, 252, 252, 252),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData['email'] ?? 'N/A', // User email
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(235, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Settings options
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildSettingOption(
                        icon: Icons.person,
                        title: 'Account Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminAccountSettings(),
                            ),
                          );
                        },
                      ),
                      _buildSettingOption(
                        icon: Icons.lock,
                        title: 'Change Password',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeAdminPasswordPage(),
                            ),
                          );
                        },
                      ),
                      _buildSettingOption(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => NotificationsPage(),
                          //   ),
                          // );
                        },
                      ),
                      
              
                      _buildSettingOption(
                        icon: Icons.exit_to_app,
                        title: 'Logout',
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 179, 204, 224), size: 28),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // Logout from Firebase
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacementNamed(
                  context, '/login'); // Navigate to login
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
