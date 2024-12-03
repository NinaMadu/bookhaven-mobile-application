import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> offers = [];
  Set<String> clearedNotifications = {}; // Track cleared notifications
  bool isLoading = true; // Track loading state
  late AnimationController _animationController; // Animation controller

  @override
  void initState() {
    super.initState();
    _fetchOffers(); // Fetch the offers when the page is initialized
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to fetch offers from Firestore
  Future<void> _fetchOffers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Offer').get();

      List<Map<String, dynamic>> fetchedOffers = querySnapshot.docs.map((doc) {
        return {
          "id":
              doc.id, // Add document ID to uniquely identify each notification
          "title": doc["title"] ?? "No Title",
          "image": doc["image"] ?? "",
        };
      }).toList();

      setState(() {
        offers = fetchedOffers;
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching offers: $e");
    }
  }

  // Function to clear all notifications with animation
  void _clearAllNotifications() async {
    await _animationController.forward(); // Play animation
    setState(() {
      clearedNotifications.addAll(offers.map((offer) => offer["id"]));
    });
    _animationController.reset(); // Reset animation
  }

  // Function to clear a single notification
  void _clearNotification(String id) {
    setState(() {
      clearedNotifications.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter offers to exclude cleared notifications
    List<Map<String, dynamic>> visibleOffers = offers
        .where((offer) => !clearedNotifications.contains(offer["id"]))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Offers"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (visibleOffers.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: _clearAllNotifications,
                  icon: const Icon(Icons.clear_all),
                  label: const Text("Clear All Notifications"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 212, 207, 206),
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : visibleOffers.isEmpty
                    ? const Center(
                        child: Text("No offers available at the moment."))
                    : ListView.builder(
                        itemCount: visibleOffers.length,
                        itemBuilder: (context, index) {
                          final offer = visibleOffers[index];
                          return _buildOfferCard(offer);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Widget to display an individual offer with swipe-to-clear
  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Dismissible(
      key: Key(offer["id"]), // Unique key for each notification
      direction: DismissDirection.endToStart, // Swipe to the left
      onDismissed: (direction) {
        _clearNotification(offer["id"]); // Clear this notification
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              offer["image"] ?? "",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 60),
            ),
          ),
          title: Text(
            offer["title"] ?? "No Title",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text("Swipe left to remove."),
        ),
      ),
    );
  }
}
