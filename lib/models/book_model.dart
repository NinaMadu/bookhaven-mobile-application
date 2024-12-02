class Book {
  String title;
  String author;
  String category;
  String description;
  String image;
  double price;
  double rating;

  // Constructor
  Book({
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    this.rating = 0, // Default rating is set to 0
  });

  // Factory method to create a Book instance from a Firestore document
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      author: map['author'],
      category: map['category'],
      description: map['description'],
      image: map['image'],
      price: map['price'].toDouble(),
      rating: map['rating']?.toDouble() ?? 0, // Handle null rating
    );
  }

  // Method to convert Book object to map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'image': image,
      'price': price,
      'rating': rating,
    };
  }
}
