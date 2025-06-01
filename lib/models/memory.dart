class Memory {
  final String imagePath;
  final String description;
  final DateTime dateTime;

  Memory({
    required this.imagePath,
    required this.description,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      imagePath: json['imagePath'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
} 