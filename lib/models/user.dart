class User {
  final String id;
  final String fullName;
  final String profileImage;
  final String contactInfo;
  final String email;
  final String phoneNumber;
  final String? location;
  final DateTime? dateOfBirth;
  final Map<String, bool> notificationPreferences;
  final List<String> paymentMethods;
  final List<String> taskHistory;
  final DateTime createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.contactInfo,
    required this.email,
    required this.phoneNumber,
    this.location,
    this.dateOfBirth,
    required this.notificationPreferences,
    required this.paymentMethods,
    required this.taskHistory,
    required this.createdAt,
  });

  // Factory method to create a User from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['name'],
      profileImage: json['profileImage'],
      contactInfo: json['contactInfo'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      notificationPreferences: Map<String, bool>.from(json['notificationPreferences']),
      paymentMethods: List<String>.from(json['paymentMethods']),
      taskHistory: List<String>.from(json['taskHistory']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': fullName,
      'profileImage': profileImage,
      'contactInfo': contactInfo,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'notificationPreferences': notificationPreferences,
      'paymentMethods': paymentMethods,
      'taskHistory': taskHistory,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // CopyWith method
  User copyWith({
    String? id,
    String? fullName,
    String? profileImage,
    String? contactInfo,
    String? email,
    String? phoneNumber,
    String? location,
    DateTime? dateOfBirth,
    Map<String, bool>? notificationPreferences,
    List<String>? paymentMethods,
    List<String>? taskHistory,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      contactInfo: contactInfo ?? this.contactInfo,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      taskHistory: taskHistory ?? this.taskHistory,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
