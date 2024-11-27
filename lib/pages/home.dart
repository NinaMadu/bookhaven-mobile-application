import 'package:bookshop/pages/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = [
    "Fiction",
    "Non-fiction",
    "Science",
    "Mystery",
    "Romance",
  ];

  final Map<String, List<Map<String, String>>> books = {
    "Fiction": [
      {"title": "The Great Gatsby", "price": "\$10", "image": "assets/icons/images/book.png"},
      {"title": "1984", "price": "\$12", "image": "assets/icons/images/book.png"},
    ],
    "Non-fiction": [
      {"title": "Sapiens", "price": "\$15", "image": "assets/nonfiction1.jpg"},
      {"title": "Educated", "price": "\$14", "image": "assets/nonfiction2.jpg"},
    ],
    "Science": [
      {"title": "A Brief History of Time", "price": "\$18", "image": "assets/science1.jpg"},
      {"title": "The Selfish Gene", "price": "\$16", "image": "assets/science2.jpg"},
    ],
    "Mystery": [
      {"title": "Gone Girl", "price": "\$11", "image": "assets/mystery1.jpg"},
      {"title": "Sherlock Holmes", "price": "\$13", "image": "assets/mystery2.jpg"},
    ],
    "Romance": [
      {"title": "Pride and Prejudice", "price": "\$9", "image": "assets/romance1.jpg"},
      {"title": "The Notebook", "price": "\$10", "image": "assets/romance2.jpg"},
    ],
  };

  final List<Map<String, String>> offers = [
    {"title": "Buy 1 Get 1 Free", "image": "assets/offer1.jpg"},
    {"title": "20% Off on Bestsellers", "image": "assets/offer2.jpg"},
    {"title": "Flat \$5 Off on Science Books", "image": "assets/offer3.jpg"},
  ];

  String selectedCategory = "Fiction"; // Default category

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Home Page Content")),
    const Center(child: Text("Search Page Content")),
    const Center(child: Text("Favorites Page Content")),
    const ProfilePage(),
  ];

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Special Offers",
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
                return offerCard(offer["title"]!, offer["image"]!);
              },
            ),
          ),

          // Categories Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              "$selectedCategory Books",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          // Wrap the book grid inside a SingleChildScrollView to make it scrollable
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: books[selectedCategory]?.length ?? 0,
                itemBuilder: (context, index) {
                  final book = books[selectedCategory]![index];
                  return bookCard(book["title"]!, book["image"]!, book["price"]!);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
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
            // Navigate to cart page
          },
        ),
      ],
    );
  }

  Widget offerCard(String title, String image) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget bookCard(String title, String image, String price) {
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
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              price,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
