class Availability {
  final Map<String, List<String>> availableDays; // e.g., {"Monday": ["9:00 AM", "5:00 PM"]}

  Availability({required this.availableDays});

  // Factory method to create Availability from JSON
  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      availableDays: (json['availableDays'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }

  // Convert Availability object to JSON
  Map<String, dynamic> toJson() {
    return {
      'availableDays': availableDays,
    };
  }
}
