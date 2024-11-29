class CartItem {
  final String bookId;
  final int quantity;

  CartItem({required this.bookId, required this.quantity});

  // Convert CartItem to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'quantity': quantity,
    };
  }

  // Create CartItem from Firestore document
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      bookId: map['bookId'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }
}
