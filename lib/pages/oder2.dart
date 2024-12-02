import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order2Page extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const Order2Page({
    Key? key,
    required this.cartItems,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _Order2PageState createState() => _Order2PageState();
}

class _Order2PageState extends State<Order2Page> {
  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  String _paymentMethod = 'Cash on delivery';
  String _deliveryType = 'Normal Delivery';
  double _additionalDeliveryFee = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final uid = user.uid;

      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        setState(() {
          _nameController.text = userData?['name'] ?? '';
          _phoneController.text = userData?['phone'] ?? '';
          _addressController.text = userData?['address'] ?? '';
        });
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  Widget _buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Books',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 16, 57, 129),
          ),
        ),
        const SizedBox(height: 14),
        ListView.builder(
          itemCount: widget.cartItems.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = widget.cartItems[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 100,
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Quantity: ${item['quantity']}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "\$${(item['price'] * item['quantity']).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 18, 29, 114),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const Text(
          "Customer Information",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                '\$${widget.totalPrice}',
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
                '\$${(widget.totalPrice + _additionalDeliveryFee).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmOrder() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final orderId = FirebaseFirestore.instance.collection('orders').doc().id;

      final orderData = {
        'userId': user.uid,
        'userName': _nameController.text,
        'userPhone': _phoneController.text,
        'userAddress': _addressController.text,
        'paymentMethod': _paymentMethod,
        'deliveryType': _deliveryType,
        'instructions': _instructionsController.text,
        'totalAmount': widget.totalPrice + _additionalDeliveryFee,
        'orderStatus': 'Pending',
        'orderDate': Timestamp.now(),
        'cartItems': widget.cartItems,
      };

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderData);

      // Clear the cart or navigate back to the cart page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCustomerInfo(),
            const SizedBox(height: 20),
            _buildPaymentInfo(),
            const SizedBox(height: 20),
            _buildDeliveryType(),
            const SizedBox(height: 20),
            _buildAdditionalInstructions(),
            const SizedBox(height: 20),
            _buildTotalPrice(widget.totalPrice),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmOrder,
              child: const Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
