import 'package:bookshop/pages/admin/addnewbook.dart';
import 'package:bookshop/pages/admin/editbookpage.dart'; // Import the EditBookPage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Management"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Stream to listen to changes in the 'Book' collection
        stream: FirebaseFirestore.instance.collection('Book').snapshots(),
        builder: (context, snapshot) {
          // Loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error handling
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Check if there is no data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No books available"));
          }

          var books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index];
              var bookId =
                  book.id; // Using Firestore document ID as the unique UID
              var title = book['title'] ?? 'No Title';
              var price = book['price'] ?? 'No Price';
              var author = book['author'] ?? 'No Author';
              var category = book['category'] ?? 'No Category';
              var imageUrl = book['image'] ?? '';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: GestureDetector(
                  // Wrap the ListTile with GestureDetector to detect taps
                  onTap: () {
                    // Navigate to the EditBookPage with the bookId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditBookPage(bookId: bookId)),
                    );
                  },
                  child: ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(imageUrl,
                            width: 50, height: 50, fit: BoxFit.cover)
                        : Icon(Icons.book, size: 50),
                    title: Text(title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Author: $author'),
                        Text('Category: $category'),
                        Text('Price: LKR $price'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Show a confirmation dialog and delete the book
                        _deleteBook(context, bookId);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Floating Action Button for adding new book (if needed)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page where the admin can add a new book
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewBookPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to delete a book from Firestore
  Future<void> _deleteBook(BuildContext context, String bookId) async {
    try {
      await FirebaseFirestore.instance.collection('Book').doc(bookId).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Book deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete book')));
    }
  }
}
