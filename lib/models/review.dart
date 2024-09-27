import 'package:fit_pro_client/models/task_group.dart';

class Review {
  final String reviewerId;
  final String reviewerName;
  final String reviewText;
  final double rating;
  final DateTime reviewDate;
  final String profileImage;
  final TaskGroup taskGroup;

  Review({
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.reviewDate,
    required this.profileImage,
    required this.taskGroup,
  });

  // Factory method to create a Review from a JSON object
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewerId: json['reviewerId'],
      reviewerName: json['reviewerName'],
      reviewText: json['reviewText'],
      rating: json['rating'].toDouble(),
      reviewDate: DateTime.parse(json['reviewDate']),
      profileImage: json['profileImage'],
      taskGroup: TaskGroup.fromJson(json['taskGroup']),
    );
  }

  // Convert Review object to JSON
  Map<String, dynamic> toJson() {
    return {
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'reviewText': reviewText,
      'rating': rating,
      'reviewDate': reviewDate.toIso8601String(),
      'profileImage': profileImage,
      'taskGroup': taskGroup.toJson(),
    };
  }
}
