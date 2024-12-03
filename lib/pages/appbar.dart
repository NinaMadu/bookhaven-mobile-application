import 'package:bookshop/pages/cartpage.dart';
import 'package:bookshop/pages/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String? getCurrentUserId() {
  final User? user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

AppBar appBar(BuildContext context) {
  final userId =
      getCurrentUserId(); // Replace with your method to get the current user's ID.

  return AppBar(
    title: const Text(
      'Book Haven',
      style: TextStyle(color: Colors.black),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    actions: [
      // Notification Icon
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users') // Replace with your Firestore collection name
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          final cartCount =
              (snapshot.data?.data() as Map<String, dynamic>?)?['notifications']
                      ?.length ??
                  0;

          return IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications,
                    color: Colors.black), // Cart icon
                if (cartCount > 0) // Show count if cart is not empty
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationsPage(), // Navigate to CartPage
                ),
              );
            },
          );
        },
      ),

      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users') // Replace with your Firestore collection name
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          final cartCount =
              (snapshot.data?.data() as Map<String, dynamic>?)?['cart']
                      ?.length ??
                  0;

          return IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart,
                    color: Colors.black), // Cart icon
                if (cartCount > 0) // Show count if cart is not empty
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(), // Navigate to CartPage
                ),
              );
            },
          );
        },
      ),
    ],
  );
}
