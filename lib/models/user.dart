class User {
  final String id;
  final String fullName;
  final String profileImage;
  final String contactInfo;

  User({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.contactInfo,
  });

  // Factory method to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['name'],
      profileImage: json['profileImage'],
      contactInfo: json['contactInfo'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': fullName,
      'profileImage': profileImage,
      'contactInfo': contactInfo,
    };
  }
}
