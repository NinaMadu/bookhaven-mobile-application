import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAccountSettings extends StatefulWidget {
  @override
  _AdminAccountSettingsState createState() => _AdminAccountSettingsState();
}

class _AdminAccountSettingsState extends State<AdminAccountSettings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String avatarUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentAdminData(); // Fetch admin data dynamically
  }

  // Method to fetch current admin data dynamically
  Future<void> _fetchCurrentAdminData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Query the admin collection for the admin with a specific identifier (e.g., id = 'admin1')
      final QuerySnapshot adminSnapshot = await _firestore
          .collection('admin')
          .where('id',
              isEqualTo: 'admin1') // Dynamically filter for current admin
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        final adminData =
            adminSnapshot.docs.first.data() as Map<String, dynamic>;
        print(
            "Admin Data Fetched: $adminData"); // Print fetched data to the console

        setState(() {
          _usernameController.text = adminData['username'] ?? '';
          _emailController.text = adminData['email'] ?? '';
          _phoneController.text = adminData['phone'] ?? '';
          avatarUrl = adminData['avatar'] ?? '';
          _isLoading = false;
        });
      } else {
        print("No admin data found for the given query.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No admin data found for the given query.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching admin data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch admin data: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to save updated admin data
  Future<void> _saveUpdates() async {
    try {
      final QuerySnapshot adminSnapshot = await _firestore
          .collection('admin')
          .where('id', isEqualTo: 'admin1')
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        final String docId = adminSnapshot.docs.first.id;

        await _firestore.collection('admin').doc(docId).update({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'avatar': avatarUrl, // Update avatar URL if needed
        });

        print("Admin data updated successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        print("No admin document found to update.");
      }
    } catch (e) {
      print("Error saving admin data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save updates: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Account Settings")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Display profile picture
                  avatarUrl.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          radius: 50,
                        )
                      : const Icon(Icons.account_circle, size: 50),
                  const SizedBox(height: 16.0),
                  // Username field
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  const SizedBox(height: 16.0),
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16.0),
                  // Phone field
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _fetchCurrentAdminData, // Reset data
                        child: const Text('Reset'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 226, 232, 242),
                          foregroundColor: const Color.fromARGB(
                              255, 21, 15, 74),
                             
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Optional padding
                        )
                      ),
                      const SizedBox(width: 20.0),
                      ElevatedButton(
                        onPressed: _saveUpdates, // Save updated data
                        child: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 9, 34, 77),
                          foregroundColor: Colors.white, // Set background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Optional padding
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
