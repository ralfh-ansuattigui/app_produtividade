class Task {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final int quadrant; // 1..4
  final int priority; // mantido para compatibilidade
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.quadrant = 1,
    this.priority = 1,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Task copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    bool? isCompleted,
    int? quadrant,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      quadrant: quadrant ?? this.quadrant,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
      'priority': priority,
      'quadrant': quadrant,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      userId: map['user_id'] as int? ?? 1,
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: (map['is_completed'] ?? 0) == 1,
      priority: map['priority'] as int? ?? 1,
      quadrant: map['quadrant'] as int? ?? 1,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}
