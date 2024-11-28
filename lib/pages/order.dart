import 'package:flutter/material.dart';

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
  // Controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _timeSlotController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  String _paymentMethod = 'Cash on delivery'; // Default payment method
  String _deliveryType = 'Normal Delivery'; // Default delivery type
  double _additionalDeliveryFee = 0.0; // Additional fee for fast delivery

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Book Details
              Container(
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
                      child: Image.asset(
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
              ),
              const SizedBox(height: 24),

              // Customer Information Section
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
              const SizedBox(height: 20),

              // Payment Information Section
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
                items: <String>['Cash on delivery', 'Digital Wallets', 'Bank Transfer']
                    .map<DropdownMenuItem<String>>((String value) {
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
              const SizedBox(height: 14),
              if (_paymentMethod == 'Digital Wallets' || _paymentMethod == 'Bank Transfer') 
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Payment Details',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 20),

              // Delivery Type Section
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
                    // Set delivery fee based on the delivery type
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
              const SizedBox(height: 20),

              // Total Price Display
              Container(
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
                    Text(
                      'Total Price:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Order Button
              ElevatedButton(
                onPressed: () {
                  // Here you can add the logic to process the order
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                  Navigator.pop(context); // Go back after order is placed
                },
                child: const Text("Confirm Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 41, 86),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
