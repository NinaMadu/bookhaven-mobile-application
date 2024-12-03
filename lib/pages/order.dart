import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/models/order_model.dart';

class OrderPage extends StatefulWidget {
  final String title;
  final String image;
  final String price;
  final String author;

  const OrderPage({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
    required this.author,
  }) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String _paymentMethod = 'Cash on delivery';
  String _deliveryType = 'Normal Delivery';
  double _additionalDeliveryFee = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the current user's UID
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Fetch user data from Firestore using UID
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = userData['name'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
        });
      } else {
        throw Exception("User data not found");
      }
    } catch (e) {
      // Handle errors
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double basePrice = double.tryParse(widget.price) ?? 0.0;
    double totalPrice = basePrice + _additionalDeliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Book'),
        backgroundColor: const Color(0xFFE9E7E7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Details
                    _buildBookDetails(),
                    const SizedBox(height: 24),

                    // Customer Information
                    _buildCustomerInfo(),
                    const SizedBox(height: 20),

                    // Payment Information
                    _buildPaymentInfo(),
                    const SizedBox(height: 20),

                    // Delivery Type
                    _buildDeliveryType(),
                    const SizedBox(height: 20),

                    // Additional Instructions
                    _buildAdditionalInstructions(),
                    const SizedBox(height: 20),

                    // Total Price
                    _buildTotalPrice(totalPrice),
                    const SizedBox(height: 20),

                    // Confirm Order Button
                    _buildConfirmOrderButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBookDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.image,
              height: 100,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Author: ${widget.author}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: ${widget.price}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Customer Information",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Delivery Address',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Information",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _paymentMethod,
          onChanged: (String? newValue) {
            setState(() {
              _paymentMethod = newValue!;
            });
          },
          items: <String>[
            'Cash on delivery',
            'Digital Wallets',
            'Bank Transfer'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: const InputDecoration(
            labelText: 'Payment Method',
            prefixIcon: Icon(Icons.payment),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Delivery Type",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _deliveryType,
          onChanged: (String? newValue) {
            setState(() {
              _deliveryType = newValue!;
              _additionalDeliveryFee = newValue == 'Fast Delivery' ? 50.0 : 0.0;
            });
          },
          items: <String>['Normal Delivery', 'Fast Delivery']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: const InputDecoration(
            labelText: 'Delivery Type',
            prefixIcon: Icon(Icons.delivery_dining),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Additional Instructions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _instructionsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Any special instructions?',
            prefixIcon: Icon(Icons.notes),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPrice(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Base Price',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\$${widget.price}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Fee',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '\$$_additionalDeliveryFee',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmOrderButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _confirmOrder();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 2, 45, 121),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 60,
            vertical: 14,
          ),
          textStyle: const TextStyle(fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Confirm Order'),
      ),
    );
  }

  Future<void> _confirmOrder() async {
    // Check if all required fields are filled
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _paymentMethod.isEmpty ||
        _deliveryType.isEmpty) {
      // Show an error message if any required field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      // Fetch the current book's document ID from Firestore
      final bookQuerySnapshot = await FirebaseFirestore.instance
          .collection('Book')
          .where('title', isEqualTo: widget.title)
          .get();

      if (bookQuerySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book not found in database')),
        );
        return;
      }

      // Assuming the first match is the correct document
      final bookDocId = bookQuerySnapshot.docs.first.id;

      // Create the order object
      final order = OrderModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        orderDate: DateTime.now(),
        items: [
          {
            'bookId': bookDocId,
            'quantity': 1
          } // Save bookId as the document UID
        ],
        fullName: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        deliveryType: _deliveryType,
        paymentMethod: _paymentMethod,
        totalPrice:
            double.tryParse(widget.price) ?? 0.0 + _additionalDeliveryFee,
        additionalInstructions: _instructionsController.text.isEmpty
            ? null
            : _instructionsController.text,
      );

      // Add the order to the 'Orders' collection in Firestore
      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      await orderRef.set(order.toMap());

      // Add the order ID to the user's orders list
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      await userRef.update({
        'orders': FieldValue.arrayUnion([orderRef.id]),
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order Confirmed!')),
      );

      // Optionally, navigate the user to a confirmation or orders page
      // Navigator.pushReplacementNamed(context, '/orderConfirmation');
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm order: $e')),
      );
    }
  }
}
