import 'package:flutter/material.dart';

class BookItemPage extends StatelessWidget {
  final String title;
  final String image;
  final String price;

  const BookItemPage({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 233, 231, 231),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0), // Margin outside the border
          padding: const EdgeInsets.all(16.0), // Padding inside the border
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 237, 237, 237), // Border color
              width: 2.0, // Border width
            ),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    image,
                    height: 300,
                    
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Book Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Price
              Text(
                "Price: $price",
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 38, 88, 128),
                ),
              ),
              const SizedBox(height: 16),

              // Description Placeholder
              const Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "This is a detailed description of the book. "
                "It includes insights into the story, author, and other details.",
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Add to cart functionality
                      },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 48, 131, 50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Place order functionality
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text("Place Order"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 17, 121, 147),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          //fontWeight: FontWeight.bold,
                        ),
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
