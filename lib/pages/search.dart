import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookshop/pages/bookitem.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = ''; // Store the search query
  List<Map<String, dynamic>> searchResults = [];

  // Method to fetch books based on the search query
  Future<void> _searchBooks() async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Book')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      List<Map<String, dynamic>> books = querySnapshot.docs.map((doc) {
        return {
          "title": doc["title"] ?? "No Title",
          "category": doc["category"] ?? "Uncategorized",
          "price": doc["price"]?.toString() ?? "0",
          "image": doc["image"] ?? "",
          "author": doc["author"] ?? "Unknown Author",
          "description": doc["description"] ?? "No Description",
        };
      }).toList();

      setState(() {
        searchResults = books;
      });
    } catch (e) {
      print("Error searching books: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0) ,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
                _searchBooks(); // Perform the search
              },
              decoration: InputDecoration(
                labelText: 'Search for books...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            // Display search results
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('No books found'))
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final book = searchResults[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          title: Text(book['title']),
                          subtitle: Text(book['author']),
                          leading: Image.network(
                            book['image'],
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: () {
                            // Navigate to the BookItemPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookItemPage(
                                  title: book['title'],
                                  image: book['image'],
                                  price: book['price'],
                                  author: book['author'],
                                  description: book['description'],
                                ),
                              ),
                            );
                          },
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
