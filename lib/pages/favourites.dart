import 'package:bookshop/pages/oder2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String userId;
  List<Map<String, dynamic>> favouriteItems = [];

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
      _fetchFavouriteItems(); // Fetch favourite items when the page initializes
    } else {
      // Handle unauthenticated user
      Navigator.pushReplacementNamed(context, '/login'); // Or show login screen
    }
  }

  Future<void> _fetchFavouriteItems() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists ||
          userDoc.data() == null ||
          userDoc["favourites"] == null) {
        debugPrint("Favourites field is missing or empty in Firestore.");
        setState(() {
          favouriteItems = [];
        });
        return;
      }

      final favourites = userDoc["favourites"] as List<dynamic>;
      if (favourites.isEmpty) {
        debugPrint("Favourites are empty in Firestore.");
        setState(() {
          favouriteItems = [];
        });
        return;
      }

      List<Map<String, dynamic>> items = [];
      for (var bookId in favourites) {
        final bookDoc = await _firestore.collection('Book').doc(bookId).get();
        if (bookDoc.exists) {
          final bookData = bookDoc.data();
          // Ensure 'image' exists before accessing it
          if (bookData != null && bookData.containsKey('image')) {
            items.add({
              'bookId': bookId, // bookId is the UID of the book document
              'imageUrl': bookData['image'], // 'image' field
              'title': bookData['title'],
              'price': bookData['price'],
            });
          } else {
            debugPrint("Missing 'image' for bookId: $bookId");
            items.add({
              'bookId': bookId,
              'imageUrl': 'https://default-image-url.com', // fallback image
              'title': bookData?['title'] ?? 'Unknown', // fallback title
              'price': bookData?['price'] ?? 0, // fallback price
            });
          }
        } else {
          debugPrint("Book document not found for bookId: $bookId");
        }
      }

      debugPrint("Items fetched: $items");

      setState(() {
        favouriteItems = items;
      });
    } catch (e) {
      debugPrint('Error fetching favourite items: $e');
    }
  }

  Future<void> removeFavourite(int index) async {
    final bookId = favouriteItems[index]['bookId'];
    try {
      final userDoc = _firestore.collection('users').doc(userId);

      // Ensure you remove the item from Firestore
      await userDoc.update({
        'favourites':
            FieldValue.arrayRemove([bookId]), // Removing just the bookId
      });

      setState(() {
        favouriteItems.removeAt(index); // Remove the item locally from UI
      });
    } catch (e) {
      debugPrint('Error removing item from favourites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
      ),
      body: favouriteItems.isEmpty
          ? const Center(
              child: Text(
                "Your favourites are empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: favouriteItems.length,
                      itemBuilder: (context, index) {
                        final item = favouriteItems[index];
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
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => removeFavourite(index),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
