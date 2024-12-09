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
    _fetchCurrentAdminData();
  }

  Future<void> _fetchCurrentAdminData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final QuerySnapshot adminSnapshot = await _firestore
          .collection('admin')
          .where('id', isEqualTo: 'admin1')
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        final adminData =
            adminSnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          _usernameController.text = adminData['username'] ?? '';
          _emailController.text = adminData['email'] ?? '';
          _phoneController.text = adminData['phone'] ?? '';
          avatarUrl = adminData['avatar'] ?? '';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No admin data found for the given query.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch admin data: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          'avatar': avatarUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No admin document found to update.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save updates: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Account Settings"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (avatarUrl.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 50,
                    )
                  else
                    const Icon(Icons.account_circle, size: 50),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    controller: _usernameController,
                    label: 'Username',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildButton(
                        label: 'Reset',
                        onPressed: _fetchCurrentAdminData,
                        color: Colors.grey[200]!,
                        textColor: Colors.black,
                      ),
                      _buildButton(
                        label: 'Save',
                        onPressed: _saveUpdates,
                        color: const Color.fromARGB(255, 90, 19, 99),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String label,
      required VoidCallback onPressed,
      required Color color,
      required Color textColor}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(label),
    );
  }
}
