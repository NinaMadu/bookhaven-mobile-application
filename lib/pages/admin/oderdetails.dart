import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  OrderDetailsPage({required this.orderId});

  Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    final orderDoc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get();
    if (!orderDoc.exists) {
      throw Exception("Order not found");
    }
    final orderData = orderDoc.data()!;
    final userId = orderData['userId'];
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      throw Exception("User not found");
    }

    final userData = userDoc.data()!;
    final items = orderData['items'] as List<dynamic>;

    // Fetch book details for each bookId in the items list
    final bookDetailsFutures = items.map((item) async {
      print("Fetching book details for ID: ${item['bookId']}");
      final bookDoc = await FirebaseFirestore.instance
          .collection('Book')
          .doc(item['bookId'])
          .get();

      if (!bookDoc.exists) {
        print("Book ID ${item['bookId']} does not exist.");
        return {
          'bookId': item['bookId'],
          'quantity': item['quantity'],
          'title': 'Unknown',
          'price': 0,
          'image': null,
        };
      }
      final bookData = bookDoc.data()!;
      print("Fetched book data: $bookData");
      return {
        'bookId': item['bookId'],
        'quantity': item['quantity'],
        'title': bookData['title'] ?? 'Unknown',
        'price': bookData['price'] ?? 0,
        'image': bookData['image'] ?? null,
      };
    }).toList();

    final bookDetails = await Future.wait(bookDetailsFutures);

    return {
      'order': orderData,
      'user': userData,
      'items': bookDetails,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Order not found"));
          }

          final orderData = snapshot.data!['order'];
          final userData = snapshot.data!['user'];
          final items = snapshot.data!['items'];

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order ID: $orderId",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Full Name: ${orderData['fullName']}",
                      style: TextStyle(fontSize: 16)),
                  Text("Phone: ${orderData['phone']}",
                      style: TextStyle(fontSize: 16)),
                  Text("Address: ${orderData['address']}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text("User Details:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("User Name: ${userData['name']}",
                      style: TextStyle(fontSize: 16)),
                  Text("User Email: ${userData['email']}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text("Order Details:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Delivery Type: ${orderData['deliveryType']}",
                      style: TextStyle(fontSize: 16)),
                  Text("Order Date: ${orderData['orderDate']}",
                      style: TextStyle(fontSize: 16)),
                  Text("Payment Method: ${orderData['paymentMethod']}",
                      style: TextStyle(fontSize: 16)),
                  Text("Total Price: \$${orderData['totalPrice']}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text("Items:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...items.map((item) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: item['image'] != null
                            ? Image.network(item['image'],
                                width: 50, height: 50, fit: BoxFit.cover)
                            : null,
                        title:
                            Text(item['title'], style: TextStyle(fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: \$${item['price']}"),
                            Text("Quantity: ${item['quantity']}"),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
