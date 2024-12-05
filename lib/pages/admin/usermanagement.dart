import 'package:bookshop/pages/admin/userdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage All Users")),
      body: StreamBuilder<QuerySnapshot>(
        // Stream to listen to changes in the 'users' collection
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users found"));
          }

          // If data is available, create a list of users
          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userId = user.id; // User document ID
              var name = user['name'] ?? 'No Name';
              var email = user['email'] ?? 'No Email';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(name, style: TextStyle(fontSize: 18)),
                  subtitle: Text(email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailPage(userId: userId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
