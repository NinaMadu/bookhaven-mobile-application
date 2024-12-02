class OrderModel {
  final String userId;
  final DateTime orderDate;
  final List<Map<String, dynamic>> items; // List of book IDs and their quantities
  final String fullName;
  final String phone;
  final String address;
  final String deliveryType;
  final String paymentMethod;
  final double totalPrice;
  final String? additionalInstructions; // Nullable field for additional instructions
  final String orderStatus; // New field for tracking order status

  // Constructor with default orderStatus value
  OrderModel({
    required this.userId,
    required this.orderDate,
    required this.items,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.deliveryType,
    required this.paymentMethod,
    required this.totalPrice,
    this.additionalInstructions, // This is nullable
    this.orderStatus = 'pending', // Default value is 'pending'
  });

  // Convert the Order object to a Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'orderDate': orderDate.toIso8601String(),
      'items': items,
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'deliveryType': deliveryType,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
      'additionalInstructions': additionalInstructions, // Nullable, will be null if not provided
      'orderStatus': orderStatus, // Include the order status in the map
    };
  }

  // Factory constructor to create an Order from Firestore data (if needed)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] ?? '',
      orderDate: DateTime.parse(map['orderDate']),
      items: List<Map<String, dynamic>>.from(map['items']),
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      deliveryType: map['deliveryType'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      additionalInstructions: map['additionalInstructions'],
      orderStatus: map['orderStatus'] ?? 'pending', // Default to 'pending' if not found
    );
  }
}
