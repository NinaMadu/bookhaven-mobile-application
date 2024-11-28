class UserModel {
  final String id;
  final String name;
  final String? phone; // Optional
  final String? address; // Optional
  final String email;
  final String avatar;

  static const String defaultAvatarUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgzlAIaq9_fY1FwvEaetGEades903CrQ0syQ&s'; // Replace with your default avatar URL

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    required this.email,
    String? avatar,
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
    );
  }
}
