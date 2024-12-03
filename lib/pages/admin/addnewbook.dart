import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNewBookPage extends StatefulWidget {
  @override
  _AddNewBookPageState createState() => _AddNewBookPageState();
}

class _AddNewBookPageState extends State<AddNewBookPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String category = '';
  double price = 0.0;
  String imageUrl = '';

  // Function to add a new book to Firestore
  Future<void> _addBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Book').add({
          'title': title,
          'author': author,
          'category': category,
          'price': price,
          'image': imageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book added successfully')));
        Navigator.pop(context);  // Go back to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add book')));
      }
    }
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
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author'),
                onChanged: (value) => setState(() => author = value),
                validator: (value) => value!.isEmpty ? 'Please enter an author' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) => setState(() => category = value),
                validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => price = double.tryParse(value) ?? 0.0),
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Please enter a valid price'
                    : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: (value) => setState(() => imageUrl = value),
                validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: Text('Add Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
