import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    // Simulate a delay (e.g., network call)
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      cartItems = ['Item 1', 'Item 2', 'Item 3']; // Example items
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: isLoading
          ? ListView.builder(
              itemCount: 5, // Placeholder items
              itemBuilder: (context, index) {
                return SkeletonLoader();
              },
            )
          : cartItems.isEmpty
              ? Center(child: Text('Your cart is empty'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cartItems[index]),
                    );
                  },
                ),
    );
  }
}

// Skeleton loading widget
class SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
          ),
          SizedBox(width: 15),
          Container(
            width: 200,
            height: 20,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
