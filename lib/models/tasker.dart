import 'package:fit_pro_client/models/availability.dart';
import 'review.dart';
import 'tasker_skill.dart';

class Tasker {
  final String id;
  final String fullName;
  final String profileImage;
  final String mapProfileImage;
  final String contactInfo;
  bool isFavorite;
  final double rating;
  final String videoPresentationUrl;
  final List<Review> reviews;
  final List<TaskerSkill> skills;
  final String bio;
  final double averagePrice;
  final Availability availability;
  final int totalNumberTasks;
  String? taskerArea;

  Tasker({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.mapProfileImage,
    required this.contactInfo,
    this.isFavorite = false,
    required this.rating,
    required this.videoPresentationUrl,
    required this.reviews,
    required this.skills,
    required this.bio,
    required this.averagePrice,
    required this.availability,
    required this.totalNumberTasks,
    this.taskerArea,
  });

  // Factory method to create a Tasker from a JSON object
  factory Tasker.fromJson(Map<String, dynamic> json) {
    return Tasker(
      id: json['id'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
      mapProfileImage: json['mapProfileImage'],
      contactInfo: json['contactInfo'],
      isFavorite: json['isFavorite'] ?? false,
      rating: json['rating'].toDouble(),
      videoPresentationUrl: json['videoPresentationUrl'],
      reviews: (json['reviews'] as List)
          .map((reviewJson) => Review.fromJson(reviewJson))
          .toList(),
      skills: (json['skills'] as List)
          .map((skillJson) => TaskerSkill.fromJson(skillJson))
          .toList(),
      bio: json['bio'],
      averagePrice: json['averagePrice'].toDouble(),
      availability: Availability.fromJson(json['availability']),
      totalNumberTasks: json['totalNumberTasks'],
      taskerArea: json['taskerArea'],
    );
  }

  // Convert Tasker object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profileImage': profileImage,
      'mapProfileImage': mapProfileImage,
      'contactInfo': contactInfo,
      'isFavorite': isFavorite,
      'rating': rating,
      'videoPresentationUrl': videoPresentationUrl,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'skills': skills.map((taskerSkill) => taskerSkill.toJson()).toList(),
      'bio': bio,
      'averagePrice': averagePrice,
      'availability': availability.toJson(),
      'totalNumberTasks': totalNumberTasks,
      'taskerArea': taskerArea,
    };
  }
}
