class AdminModel {
  final String id;
  final String username;
  final String? phone; // Optional
  final String email;
  final String password; // Optional, used for authentication
  final String avatar; // You can add a default avatar if you like

  static const String defaultAvatarUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRodNrae8IXtSESlaOhZwc1GALzLRogskNgJQ&s'; // Default avatar URL

  AdminModel({
    required this.id,
    required this.username,
    this.phone,
    required this.email,
    required this.password,
    String? avatar,
  }) : avatar = avatar ?? defaultAvatarUrl;

  // Convert AdminModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'phone': phone,
      'email': email,
      'password': password,
      'avatar': avatar,
    };
  }

  // Create AdminModel from Firestore document
  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'], // May be null
      email: map['email'] ?? '',
      password: map['password'] ?? '', // Password is a required field for login
      avatar: map['avatar'] ?? defaultAvatarUrl,
    );
  }
}
