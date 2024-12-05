import 'package:bookshop/pages/oder2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String userId;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
      _fetchCartItems(); // Fetch cart items when the page initializes
    } else {
      // Handle unauthenticated user
      Navigator.pushReplacementNamed(context, '/login'); // Or show login screen
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists ||
          userDoc.data() == null ||
          userDoc["cart"] == null) {
        debugPrint("Cart field is missing or empty in Firestore.");
        setState(() {
          cartItems = [];
        });
        return;
      }

      final cart = userDoc["cart"] as List<dynamic>;
      if (cart.isEmpty) {
        debugPrint("Cart is empty in Firestore.");
        setState(() {
          cartItems = [];
        });
        return;
      }

      List<Map<String, dynamic>> items = [];
      for (var item in cart) {
        final bookDoc =
            await _firestore.collection('Book').doc(item['bookId']).get();
        if (bookDoc.exists) {
          final bookData = bookDoc.data();
          // Ensure 'image' exists before accessing it
          if (bookData != null && bookData.containsKey('image')) {
            items.add({
              'bookId': item['bookId'],
              'imageUrl': bookData['image'], // Changed to 'image' field
              'title': bookData['title'],
              'price': bookData['price'],
              'quantity': item['quantity'],
            });
          } else {
            debugPrint("Missing 'image' for bookId: ${item['bookId']}");
            items.add({
              'bookId': item['bookId'],
              'imageUrl': 'https://default-image-url.com', // fallback image
              'title': bookData?['title'] ?? 'Unknown', // fallback title
              'price': bookData?['price'] ?? 0, // fallback price
              'quantity': item['quantity'],
            });
          }
        } else {
          debugPrint("Book document not found for bookId: ${item['bookId']}");
        }
      }

      debugPrint("Items fetched: $items");

      setState(() {
        cartItems = items;
      });
    } catch (e) {
      debugPrint('Error fetching cart items: $e');
    }
  }

  double getSubtotal() {
    return cartItems.fold(0.0, (total, item) {
      return total + (item['price'] * item['quantity']);
    });
  }

  Future<void> updateQuantity(String bookId, int newQuantity) async {
    try {
      final userDoc = _firestore.collection('users').doc(userId);

      // Remove the old item with the previous quantity
      await userDoc.update({
        'cart': FieldValue.arrayRemove([
          {
            'bookId': bookId,
            'quantity': cartItems
                .firstWhere((item) => item['bookId'] == bookId)['quantity']
          }
        ]),
      });

      // Add the updated item with the new quantity
      await userDoc.update({
        'cart': FieldValue.arrayUnion([
          {'bookId': bookId, 'quantity': newQuantity}
        ]),
      });

      await _fetchCartItems(); // Refresh the cart items after updating the quantity
    } catch (e) {
      debugPrint('Error updating quantity: $e');
    }
  }

  void incrementQuantity(int index) {
    final item = cartItems[index];
    updateQuantity(item['bookId'], item['quantity'] + 1);
  }

  void decrementQuantity(int index) {
    final item = cartItems[index];
    if (item['quantity'] > 1) {
      updateQuantity(item['bookId'], item['quantity'] - 1);
    }
  }

  Future<void> deleteItem(int index) async {
    final bookId = cartItems[index]['bookId'];
    try {
      final userDoc = _firestore.collection('users').doc(userId);

      // Ensure you remove the item using the exact structure as in Firestore
      final itemToRemove = {
        'bookId': bookId,
        'quantity': cartItems[index]['quantity']
      };

      await userDoc.update({
        'cart': FieldValue.arrayRemove(
            [itemToRemove]), // Removing the exact item structure
      });

      setState(() {
        cartItems.removeAt(index); // Remove the item locally from UI
      });
    } catch (e) {
      debugPrint('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
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
                                      "Price: \LKR ${item["price"].toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              decrementQuantity(index),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text("${item["quantity"]}"),
                                        IconButton(
                                          onPressed: () =>
                                              incrementQuantity(index),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => deleteItem(index),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtotal",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "\LKR ${getSubtotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final totalPrice = getSubtotal();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Order2Page(
                              cartItems: cartItems, // Pass the cart items
                              totalPrice: totalPrice, // Pass the total price
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          backgroundColor:
                              const Color.fromARGB(255, 26, 87, 136),
                          foregroundColor: Colors.white),
                      child: const Text("Proceed to Checkout"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
