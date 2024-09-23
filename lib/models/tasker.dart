import 'package:google_maps_flutter/google_maps_flutter.dart';

class Tasker {
  final String fullName;
  final LatLng location;
  final double rating;
  final String profileImage;
  final String mapProfileImage;
  final String phoneNumber;
  final String email;
  final List<String> skills;
  final String bio;
  final bool isSuperPunetor;
  bool isFavorite; // New property to track if the tasker is a favorite

  Tasker({
    required this.fullName,
    required this.location,
    required this.rating,
    required this.profileImage,
    required this.mapProfileImage,
    required this.phoneNumber,
    this.email = '',
    this.skills = const [],
    this.bio = '',
    this.isSuperPunetor = false,
    this.isFavorite = false,
  });

  String get summary {
    return 'Tasker: $fullName, Rating: $rating, Location: (${location.latitude}, ${location.longitude}), Super Punëtor: $isSuperPunetor, Favorite: $isFavorite';
  }

  factory Tasker.fromJson(Map<String, dynamic> json) {
    return Tasker(
      fullName: json['full_name'],
      location: LatLng(json['location']['latitude'], json['location']['longitude']),
      rating: json['rating'].toDouble(),
      profileImage: json['profile_image'],
      mapProfileImage: json['map_profile_image'],
      phoneNumber: json['phone_number'],
      email: json['email'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      bio: json['bio'] ?? '',
      isSuperPunetor: json['is_super_punetor'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'rating': rating,
      'profile_image': profileImage,
      'map_profile_image': mapProfileImage,
      'phone_number': phoneNumber,
      'email': email,
      'skills': skills,
      'bio': bio,
      'is_super_punetor': isSuperPunetor,
      'is_favorite': isFavorite, 
    };
  }
}
