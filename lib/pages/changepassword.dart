import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _oldPassword, _newPassword, _confirmPassword;
  final _auth = FirebaseAuth.instance;

  // Function to change the password
  Future<void> _changePassword() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in.');
      }

      // Re-authenticate the user with their old password
      final credentials = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPassword!,
      );

      await user.reauthenticateWithCredential(credentials);

      // Check if new password matches confirm password
      if (_newPassword != _confirmPassword) {
        throw Exception('New password and confirm password do not match.');
      }

      // Check if new password length is at least 8 characters
      if (_newPassword!.length < 8) {
        throw Exception('Password should be at least 8 characters long.');
      }

      // Update the user's password
      await user.updatePassword(_newPassword!);

      // After updating password, sign out and navigate to login screen
      await _auth.signOut();
      Navigator.pushReplacementNamed(
          context, '/login'); // Navigate to login screen
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add padding before the image
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0), // Padding before the image
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTkU00VfHwpO5cyT8Rax9yU2rJnvZv1s7sr8cqpF-E3bKQ9CBogWnnkdV-cuCoptTIg9U&usqp=CAU',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Change Password Title
              Text(
                'Change Password',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ),
              const SizedBox(height: 30),
              // Form for Old Password, New Password, and Confirm Password
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Old Password Field
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Old Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      onSaved: (password) {
                        _oldPassword = password;
                      },
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // New Password Field
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'New Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      onSaved: (password) {
                        _newPassword = password;
                      },
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter a new password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        filled: true,
                        fillColor: Color(0xFFF5FCF9),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0 * 1.5,
                          vertical: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      onSaved: (password) {
                        _confirmPassword = password;
                      },
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Change Password Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _changePassword();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0077B5), // Blue color
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Change Password"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
