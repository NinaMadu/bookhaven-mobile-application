import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/pages/order.dart';

class BookItemPage extends StatelessWidget {
  final String title;
  final String image;
  final String price;
  final String author;
  final String description;

  const BookItemPage({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
    required this.author,
    required this.description,
  }) : super(key: key);

  Future<void> _addToCart(BuildContext context) async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("User is not signed in");
      }

      // Query Firestore to find the document ID of the current book
      final bookQuery = await FirebaseFirestore.instance
          .collection('Book') // Assuming your books collection is named 'books'
          .where('title', isEqualTo: title) // Match the book title
          .where('author', isEqualTo: author) // Match the book author
          .get();

      if (bookQuery.docs.isEmpty) {
        throw Exception("Book not found in the database.");
      }

      // Get the first matched document ID
      final bookId = bookQuery.docs.first.id;

      // Reference to the user's document
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Fetch the current cart
      final userSnapshot = await userDoc.get();
      final cart = userSnapshot.data()?['cart'] ?? [];

      // Check if the book is already in the cart
      bool isBookInCart = false;

      for (var item in cart) {
        if (item['bookId'] == bookId) {
          isBookInCart = true;
          item['quantity'] += 1; // Increment quantity
          break;
        }
      }

      if (!isBookInCart) {
        // Add new item with quantity = 1
        cart.add({'bookId': bookId, 'quantity': 1});
      }

      // Update the cart in Firestore
      await userDoc.update({'cart': cart});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to cart successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFE9E7E7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Details in a Highlighted Box
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 181, 192, 203), // Border color
                    width: 2.0, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4), // Shadow offset
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        image,
                        height: 200,
                        width: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Book Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            author,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Price: LKR $price",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 18, 67, 122),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description Section
              const Text(
                "About Book",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Buttons for Add to Cart and Place Order
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _addToCart(context), // Call the addToCart function
                      icon: const Icon(Icons.bookmark),
                      label: const Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderPage(
                              title: title,
                              image: image,
                              price: price,
                              author: author,
                            ),
                          ),
                        );
                      },
                      child: const Text("Place Order"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 77, 127),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
