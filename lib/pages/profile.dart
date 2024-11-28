import 'package:flutter/material.dart';
import 'package:bookshop/pages/accountsettings.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with a gradient background
            Container(
              decoration: BoxDecoration(
              
              ),
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/icons/images/profile.png'), // User profile image
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'John Doe', // Username
                      style: TextStyle(
                        fontSize: 26, // Slightly bigger font for the username
                        color: Color.fromARGB(255, 5, 80, 150),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'john.doe@example.com', // User email
                      style: TextStyle(
                        fontSize: 14, // Smaller font size for the email
                        color: Color.fromARGB(179, 69, 119, 199),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding for the main body content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Account Settings section
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
                      // Handle password change navigation
                    },
                  ),
                  _buildSettingOption(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      // Handle notifications settings
                    },
                  ),
                  _buildSettingOption(
                    icon: Icons.help,
                    title: 'Help & Support',
                    onTap: () {
                      // Handle help & support navigation
                    },
                  ),
                  _buildSettingOption(
                    icon: Icons.exit_to_app,
                    title: 'Logout',
                    onTap: () {
                      // Handle logout functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build individual setting options with more creative and smaller text
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
            Icon(icon, color: Colors.blue, size: 28), // Slightly larger icons
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16, // Smaller text for a more refined look
                  fontWeight: FontWeight.w600, // Bold text for emphasis
                  letterSpacing: 1.1, // Slightly increased letter spacing for readability
                  color: Colors.black87, // Darker text for better visibility
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
