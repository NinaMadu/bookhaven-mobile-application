import 'package:bookshop/pages/accountsettings.dart';
import 'package:bookshop/pages/changepassword.dart';
import 'package:bookshop/pages/loginpage.dart';
import 'package:bookshop/pages/myorders.dart'; // MyOrdersPage import
import 'package:bookshop/pages/notifications.dart';
import 'package:bookshop/pages/supportpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    final user = FirebaseAuth.instance.currentUser; // Get current user
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Use the user's UID to fetch their details
        .get();

    if (!doc.exists) {
      throw Exception('User document does not exist.');
    }

    return doc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
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
                // Profile header with gradient
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
                          radius: 60,
                          backgroundImage: NetworkImage(
                            userData['avatar'] ??
                                'https://example.com/default-avatar.png',
                          ), // User profile image
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          userData['name'] ?? 'N/A', // Username
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData['email'] ?? 'N/A', // User email
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Settings options with custom styling
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      _buildSettingOption(
                        icon: Icons.person,
                        title: 'Account Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountSettings(),
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
                              builder: (context) => ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                      _buildSettingOption(
                        icon: Icons.shopping_cart_checkout_sharp,
                        title: 'My Orders',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyOrdersPage(),
                            ),
                          );
                        },
                      ),
                      _buildSettingOption(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationsPage(),
                            ),
                          );
                        },
                      ),
                      _buildSettingOption(
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupportPage(),
                            ),
                          );
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
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading:
            Icon(icon, size: 30, color: const Color.fromARGB(255, 78, 80, 84)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Color.fromARGB(255, 157, 165, 178),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Logout',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to logout?',
              style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Logout',
                  style: TextStyle(fontSize: 16, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
