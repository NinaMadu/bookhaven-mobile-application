import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrderManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Management")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders found"));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var userId = order['userId'];
              var orderDate = order['orderDate']; // This could be Timestamp or String

              // Safely handle totalPrice, with a default value if not found
              var totalAmount = order['totalPrice'] ?? 'Not available'; 

              // If 'orderDate' is a Timestamp, convert it to DateTime
              if (orderDate is Timestamp) {
                orderDate = orderDate.toDate(); // Convert Timestamp to DateTime
              } else if (orderDate is String) {
                // If it's a string, you may still want to parse it manually
                orderDate = parseOrderDate(orderDate);
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return Center(child: Text("Error fetching user data"));
                  }

                  if (!userSnapshot.hasData) {
                    return Center(child: Text("User data not found"));
                  }

                  var user = userSnapshot.data!;
                  var userName = user['name'] ?? 'No Name';
                  var userEmail = user['email'] ?? 'No Email';

                  // Format orderDate to a readable string if it's a DateTime
                  var formattedOrderDate = orderDate != null
                      ? DateFormat('yyyy-MM-dd HH:mm:ss').format(orderDate)
                      : 'No Date';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(userName, style: TextStyle(fontSize: 18)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: $userEmail'),
                          Text('Order Date: $formattedOrderDate'),
                          Text('Total Amount: $totalAmount'), // Display totalAmount safely
                        ],
                      ),
                      onTap: () {
                        // Handle order tap if needed
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Function to parse the order date string into DateTime (if needed)
  DateTime parseOrderDate(String orderDate) {
    // Replace the "at" and "UTC" to make the date parsable
    String formattedDate = orderDate.replaceAll(' at ', ' ').replaceAll(' UTC', '');
    return DateTime.parse(formattedDate);
  }
}
