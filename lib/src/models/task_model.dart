class TaskModel {
  final String id;
  final String category;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],  // Mengambil id sebagai String
      category: map['category'],
      title: map['title'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
