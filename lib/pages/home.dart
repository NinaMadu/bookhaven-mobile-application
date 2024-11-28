import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookshop/pages/bookitem.dart';
import 'package:bookshop/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = [
    "All",
    "Fiction",
    "Non-fiction",
    "Science",
    "Mystery",
    "Romance",
  ];
  String selectedCategory = "All";
  List<Map<String, dynamic>> books = [];
  List<Map<String, dynamic>> offers = [];
  int _selectedIndex = 0; // For Bottom Navigation Bar

  final List<Widget> _pages = [
    const Center(child: Text("Home Page Content")),
    const Center(child: Text("Search Page Content")),
    const Center(child: Text("Favorites Page Content")),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _fetchOffers();
  }

  Future<void> _fetchBooks() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Book').get();

      List<Map<String, dynamic>> fetchedBooks = querySnapshot.docs.map((doc) {
        return {
          "title": doc["title"] ?? "No Title", // Default if title is missing
          "category": doc["category"] ?? "Uncategorized", // Default category
          "price": doc["price"]?.toString() ?? "0", // Ensure price is a string
          "image":
              doc["image"] ?? "", // Default empty string if image is missing
          "author":
              doc["author"] ?? "Unknown Author", // Default if author is missing
          "description": doc["description"] ??
              "No Description", // Default if description is missing
        };
      }).toList();

      setState(() {
        books = fetchedBooks; // Update the state with the fetched book data
      });
    } catch (e) {
      print("Error fetching books: $e"); // Log any errors
    }
  }

  Future<void> _fetchOffers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Offer').get();

      List<Map<String, dynamic>> fetchedOffers = querySnapshot.docs.map((doc) {
        return {
          "title": doc["title"] ?? "No Title",
          "image": doc["image"] ?? "",
        };
      }).toList();

      setState(() {
        offers = fetchedOffers;
      });
    } catch (e) {
      print("Error fetching offers: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page when the Profile tab is selected
    if (index == 3) {
      // Navigate to the Profile Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offers Section
          if (offers.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Offers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return offerCard(offer["title"], offer["image"]);
                },
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Categories Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Books Related to the Selected Category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              selectedCategory == "All"
                  ? "All Books"
                  : "$selectedCategory Books",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),

          // Display Books
          Expanded(
            child: books.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: books
                        .where((book) =>
                            selectedCategory == "All" ||
                            book["category"] == selectedCategory)
                        .length,
                    itemBuilder: (context, index) {
                      final filteredBooks = books
                          .where((book) =>
                              selectedCategory == "All" ||
                              book["category"] == selectedCategory)
                          .toList();
                      final book = filteredBooks[index];
                      return bookCard(
                        book['title'], // Title of the book
                        book['image'], // Image URL of the book
                        book['price'], // Price of the book
                        book['author'], // Author of the book
                        book['description'],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 17, 102, 172),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Book Haven',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CartPage(cartItems: cart),
            //   ),
            // ).then(
            //     (_) => setState(() {})); // Update cart if any item is removed
          },
        ),
      ],
    );
  }

  Widget bookCard(String title, String image, String price, String author,
      String description) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$${price.toString()}",
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookItemPage(
                      title: title,
                      image: image,
                      price: price,
                      author: author,
                      description: description,
                    ),
                  ),
                );
              },
              child: const Text(
                "View Book",
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.normal, // Text weight
                  fontSize: 16, // Optional: Text size
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 75, 180, 199), // Button color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget offerCard(String title, String image) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
              width: 150,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
