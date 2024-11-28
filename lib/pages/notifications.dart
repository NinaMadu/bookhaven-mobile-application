import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> offers = [];
  bool isLoading = true;  // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchOffers();  // Fetch the offers when the page is initialized
  }

  // Function to fetch offers from Firestore
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
        isLoading = false;  // Set loading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching offers: $e");
      // Optionally show an error message on the UI
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())  // Show loading spinner
          : offers.isEmpty
              ? const Center(child: Text("No offers available at the moment."))  // Show message if no offers
              : ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return _buildOfferCard(offer);
                  },
                ),
    );
  }

  // Widget to display an individual offer
  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Card(
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
        subtitle: const Text("Tap to view details."),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: () {
            // Implement offer detail navigation (if necessary)
            // For example, you could push a new screen with the offer details.
          },
        ),
      ),
    );
  }
}
