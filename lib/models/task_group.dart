class TaskGroup {
  final String id;
  final String title;
  final String description;
  double feePerHour;
  final bool isActive;

  TaskGroup({
    required this.id, 
    required this.title,
    required this.description,
    required this.feePerHour,
    this.isActive = false,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) {
    return TaskGroup(
      id: json['id'], 
      title: json['title'],
      description: json['description'],
      feePerHour: json['feePerHour']?.toDouble(),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'feePerHour': feePerHour,
      'isActive': isActive,
    };
  }
}
