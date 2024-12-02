import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': '123456',
      'items': ['Book 1', 'Book 2'],
      'totalPrice': 29.99,
      'status': 'Shipped',
      'orderDate': '2024-12-01',
    },
    {
      'orderId': '789101',
      'items': ['Book 3'],
      'totalPrice': 15.99,
      'status': 'Delivered',
      'orderDate': '2024-11-20',
    },
    {
      'orderId': '112233',
      'items': ['Book 4', 'Book 5', 'Book 6'],
      'totalPrice': 49.99,
      'status': 'Processing',
      'orderDate': '2024-12-05',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality can be added here
            },
          ),
        ],
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "You have no orders yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text('Order ID: ${order['orderId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Items: ${order['items'].join(', ')}'),
                        Text('Total: \$${order['totalPrice']}'),
                        Text('Status: ${order['status']}'),
                        Text('Order Date: ${order['orderDate']}'),
                      ],
                    ),
                    trailing: Icon(
                      order['status'] == 'Delivered'
                          ? Icons.check_circle
                          : order['status'] == 'Shipped'
                              ? Icons.local_shipping
                              : Icons.pending_actions,
                      color: order['status'] == 'Delivered'
                          ? Colors.green
                          : order['status'] == 'Shipped'
                              ? Colors.blue
                              : Colors.orange,
                    ),
                    onTap: () {
                      // Navigate to order details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                            orderId: order['orderId'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    // You can replace the content below with actual order details
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details - $orderId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Items: Book 1, Book 2, Book 3'),
            const SizedBox(height: 8),
            const Text('Total Price: \$29.99'),
            const SizedBox(height: 8),
            const Text('Status: Shipped'),
            const SizedBox(height: 8),
            const Text('Shipping Address: 123 Main St, City, Country'),
            const SizedBox(height: 8),
            const Text('Payment Method: Credit Card'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle button press (e.g., contact support, track order)
              },
              child: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: MyOrdersPage()));
