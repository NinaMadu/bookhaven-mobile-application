import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Mock cart data (replace this with data fetched from your database)
  List<Map<String, dynamic>> cartItems = [
    {
      "imageUrl": "https://via.placeholder.com/150",
      "title": "Book A",
      "price": 20.0,
      "quantity": 1,
    },
    {
      "imageUrl": "https://via.placeholder.com/150",
      "title": "Book B",
      "price": 15.0,
      "quantity": 1,
    },
    {
      "imageUrl": "https://via.placeholder.com/150",
      "title": "Book C",
      "price": 30.0,
      "quantity": 2,
    },
  ];

  // Function to calculate subtotal
  double getSubtotal() {
    return cartItems.fold(
      0.0,
      (total, item) => total + (item["price"] * item["quantity"]),
    );
  }

  // Increment item quantity
  void incrementQuantity(int index) {
    setState(() {
      cartItems[index]["quantity"] += 1;
    });
  }

  // Decrement item quantity
  void decrementQuantity(int index) {
    setState(() {
      if (cartItems[index]["quantity"] > 1) {
        cartItems[index]["quantity"] -= 1;
      }
    });
  }

  // Delete item from cart
  void deleteItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cart items list
            Expanded(
              child: cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              // Book image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item["imageUrl"]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Book details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["title"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Price: \$${item["price"].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => decrementQuantity(index),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text("${item["quantity"]}"),
                                        IconButton(
                                          onPressed: () => incrementQuantity(index),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Delete button
                              IconButton(
                                onPressed: () => deleteItem(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
            // Subtotal display
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${getSubtotal().toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Checkout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement checkout functionality here
                },
                child: const Text("Proceed to Checkout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 16, 69, 137),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              
              ),
            ),
          ],
        ),
      ),
    );
  }
}
