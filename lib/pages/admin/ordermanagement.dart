import 'package:bookshop/pages/admin/oderdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
              var orderDate = order['orderDate'];
              var totalAmount = order['totalPrice'] ?? 'Not available';

              if (orderDate is Timestamp) {
                orderDate = orderDate.toDate();
              } else if (orderDate is String) {
                orderDate = parseOrderDate(orderDate);
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
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
                  var userPhone = user['phone'] ?? 'No Phone';
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
                          Text('Phone: $userPhone'),
                          Text('Order Date: $formattedOrderDate'),
                          Text('Total Amount (LKR): $totalAmount'),
                        ],
                      ),
                      onTap: () {
                        // Navigate to the detailed view
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsPage(orderId: order.id),
                          ),
                        );
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

  DateTime parseOrderDate(String orderDate) {
    String formattedDate =
        orderDate.replaceAll(' at ', ' ').replaceAll(' UTC', '');
    return DateTime.parse(formattedDate);
  }
}
