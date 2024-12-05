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
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('orderDate', descending: true)
            .snapshots(), // Ordering by orderDate in descending order
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

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ExpansionTile(
                  title: FutureBuilder<List<String>>(
                    future: _fetchBookTitles(order['items']),
                    builder: (context, bookSnapshot) {
                      if (bookSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (bookSnapshot.hasError) {
                        return Text(
                            "Error fetching book titles: ${bookSnapshot.error}");
                      }

                      var bookTitles = bookSnapshot.data ?? [];
                      return Text(
                        bookTitles.isNotEmpty
                            ? bookTitles.join(', ')
                            : "No books found",
                        style: TextStyle(fontSize: 18),
                      );
                    },
                  ),
                  subtitle: Text(
                    orderDate != null
                        ? DateFormat('yyyy-MM-dd HH:mm:ss').format(orderDate)
                        : 'No Date',
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Amount : LKR $totalAmount'),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }

                              if (userSnapshot.hasError) {
                                return Text(
                                    "Error fetching user details: ${userSnapshot.error}");
                              }

                              if (!userSnapshot.hasData) {
                                return Text("User details not found");
                              }

                              var user = userSnapshot.data!;
                              var userName = user['name'] ?? 'No Name';
                              var userPhone = user['phone'] ?? 'No Phone';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Customer Name: $userName"),
                                  Text("Customer Phone: $userPhone"),
                                ],
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsPage(orderId: order.id),
                                ),
                              );
                            },
                            child: Text("View Details"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<String>> _fetchBookTitles(List<dynamic> items) async {
    List<String> bookTitles = [];
    for (var item in items) {
      var bookId = item['bookId'];
      var bookDoc =
          await FirebaseFirestore.instance.collection('Book').doc(bookId).get();
      if (bookDoc.exists) {
        bookTitles.add(bookDoc['title'] ?? 'Unknown Title');
      }
    }
    return bookTitles;
  }

  DateTime parseOrderDate(String orderDate) {
    String formattedDate =
        orderDate.replaceAll(' at ', ' ').replaceAll(' UTC', '');
    return DateTime.parse(formattedDate);
  }
}
