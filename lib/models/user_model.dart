import 'package:bookshop/models/CartItem.dart';

class UserModel {
  final String id;
  final String name;
  final String? phone; // Optional
  final String? address; // Optional
  final String email;
  final String avatar;
  final List<CartItem>? cart; // Nullable list of CartItems
  final List<String>? orders; // Nullable array of bookIds
  final List<String>? favourites; // Nullable array of bookIds
  final List<String>? notifications; // Nullable array of notifications

  static const String defaultAvatarUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgzlAIaq9_fY1FwvEaetGEades903CrQ0syQ&s'; // Default avatar URL

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    required this.email,
    String? avatar,
    this.cart, // Nullable
    this.orders, // Nullable
    this.favourites, // Nullable
    this.notifications, // Nullable
  }) : avatar = avatar ?? defaultAvatarUrl;

  // Convert UserModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
      'avatar': avatar,
      'cart': cart
          ?.map((item) => item.toMap())
          .toList(), // Convert CartItem list to map
      'orders': orders, // Can be null
      'favourites': favourites, // Can be null
      'notifications': notifications, // Can be null
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'], // May be null
      address: map['address'], // May be null
      email: map['email'] ?? '',
      avatar: map['avatar'] ?? defaultAvatarUrl,
      cart: map['cart'] != null
          ? List<CartItem>.from(
              map['cart'].map((item) => CartItem.fromMap(item)))
          : null, // Convert to list of CartItem
      orders: map['orders'] != null
          ? List<String>.from(map['orders'])
          : null, // Nullable
      favourites: map['favourites'] != null
          ? List<String>.from(map['favourites'])
          : null, // Nullable
      notifications: map['notifications'] != null
          ? List<String>.from(map['notifications'])
          : null, // Nullable
    );
  }
}
