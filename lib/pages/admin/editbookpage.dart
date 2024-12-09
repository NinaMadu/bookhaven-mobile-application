import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookPage extends StatefulWidget {
  final String bookId; // Assuming this is passed as a parameter
  const EditBookPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController priceController;
  late TextEditingController imageUrlController;

  String category = 'Fiction'; // Default category
  double rating = 0.0;
  bool _isImageValid = true;

  final List<String> categories = [
    "Fiction",
    "Non-fiction",
    "Science",
    "Mystery",
    "Romance",
    "Other"
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    authorController = TextEditingController();
    priceController = TextEditingController();
    imageUrlController = TextEditingController();

    _loadBookData();
  }

  Future<void> _loadBookData() async {
    try {
      var bookData = await FirebaseFirestore.instance
          .collection('Book')
          .doc(widget.bookId)
          .get();

      if (bookData.exists) {
        setState(() {
          titleController.text = bookData['title'] ?? '';
          authorController.text = bookData['author'] ?? '';
          category = bookData['category'] ?? 'Fiction'; // Default value
          priceController.text = (bookData['price'] is double)
              ? bookData['price'].toString()
              : (bookData['price'] is int)
                  ? (bookData['price'] as int).toDouble().toString()
                  : '0.0';
          imageUrlController.text = bookData['image'] ?? '';
          rating = (bookData['rating'] is double)
              ? bookData['rating']
              : (bookData['rating'] is int)
                  ? (bookData['rating'] as int).toDouble()
                  : 0.0;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Book not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load book data')));
    }
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate() && _isImageValid) {
      try {
        await FirebaseFirestore.instance
            .collection('Book')
            .doc(widget.bookId)
            .update({
          'title': titleController.text,
          'author': authorController.text,
          'category': category,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'image': imageUrlController.text,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Book updated successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update book')));
      }
    }
  }

  void _validateImageUrl(String value) {
    setState(() {
      _isImageValid = Uri.tryParse(value)?.hasAbsolutePath ?? false;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Book"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an author' : null,
              ),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty || double.tryParse(value) == null
                        ? 'Please enter a valid price'
                        : null,
              ),
              TextFormField(
                controller: imageUrlController,
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
              if (imageUrlController.text.isNotEmpty && _isImageValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(
                    imageUrlController.text,
                    width: 120,
                    height: 200,
                    fit: BoxFit.fitHeight,
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
                onPressed: _updateBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 87, 16, 100), // Purple background
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(
                      vertical: 16), // Optional: Add padding
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: Rounded corners
                  ),
                ),
                child: Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
