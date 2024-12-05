import 'package:bookshop/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/models/book_model.dart';

class AddNewBookPage extends StatefulWidget {
  @override
  _AddNewBookPageState createState() => _AddNewBookPageState();
}

class _AddNewBookPageState extends State<AddNewBookPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String category = 'Fiction'; // Default value from the categories list
  double price = 0.0;
  String imageUrl = '';
  double rating = 0.0;
  bool _isImageValid = true;

  // List of categories
  final List<String> categories = [
    "Fiction",
    "Non-fiction",
    "Science",
    "Mystery",
    "Romance",
    "Other"
  ];

  // Function to add a new book to Firestore
  Future<void> _addBook() async {
    if (_formKey.currentState!.validate() && _isImageValid) {
      try {
        // Create an instance of Book using the entered data
        Book newBook = Book(
          title: title,
          author: author,
          category: category,
          description: '', // Add description if needed
          image: imageUrl,
          price: price,
          rating: rating,
        );

        // Add the book to the Firestore collection
        await FirebaseFirestore.instance
            .collection('Book')
            .add(newBook.toMap());

        // Show success message
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Book added successfully')));

        // Go back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add book')));
      }
    }
  }

  // Method to validate image URL
  void _validateImageUrl(String value) {
    setState(() {
      imageUrl = value;
      // Check if the URL is a valid image URL
      _isImageValid = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) => setState(() => title = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                onChanged: (value) => setState(() => author = value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an author' : null,
              ),
              // Dropdown for category selection
              DropdownButtonFormField<String>(
                value:
                    category, // Ensure the value is part of the categories list
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue!;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a category'
                    : null,
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price (LKR)'),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => price = double.tryParse(value) ?? 0.0),
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Please enter a valid price'
                        : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: _validateImageUrl,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an image URL' : null,
              ),
              if (!_isImageValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Invalid image URL. Please provide a valid URL.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (imageUrl.isNotEmpty && _isImageValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(
                    imageUrl,
                    width: 120, // Set a fixed width
                    height:
                        200, // Set the height to show the full height of the image
                    fit: BoxFit
                        .fitHeight, // Maintain full height and scale width accordingly
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Purple background
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(
                      vertical: 16), // Optional: Add padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                ),
                child: Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
