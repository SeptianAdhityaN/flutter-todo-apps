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

  /// Untuk menyalin task dengan properti yang bisa diubah sebagian
  TaskModel copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    String? startDate,
    String? endDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Konversi ke Map untuk simpan ke database
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

  /// Factory method dari Map (hasil dari database) ke TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      category: map['category'],
      title: map['title'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  /// Untuk debugging: print instance-nya
  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, completed: $isCompleted)';
  }
}
