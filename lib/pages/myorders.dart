import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<MyOrdersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  String? getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> fetchOrders() async {
    try {
      final userId = getCurrentUserId();
      if (userId != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          List<dynamic> orderIds = userDoc['orders'] ?? [];
          List<Map<String, dynamic>> fetchedOrders = [];

          for (var orderId in orderIds) {
            DocumentSnapshot orderDoc =
                await _firestore.collection('orders').doc(orderId).get();

            if (orderDoc.exists) {
              fetchedOrders.add({
                'orderId': orderDoc.id,
                ...?orderDoc.data() as Map<String, dynamic>,
              });
            }
          }

          setState(() {
            orders = fetchedOrders;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text("No orders found!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    List<dynamic> cartItems = order['cartItems'] ?? [];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          "Order ID: ${order['orderId']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueAccent),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                                "Total Price: \$${order['totalPrice'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                "Order Status: ${order['orderStatus'] ?? 'Order Placed'}",
                                style: const TextStyle(fontSize: 16)),
                            Text(
                                "Order Date: ${_formatTimestamp(order['orderDate'])}",
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            const Text("Ordered Books:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            ...cartItems.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Image.network(
                                      item['imageUrl'],
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item['title'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                        "\$${item['price']} x ${item['quantity']}",
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.blueAccent),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => OrderDetailsScreen(orderData: order),
                          //   ),
                          // );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }
    return 'Invalid Date';
  }
}
