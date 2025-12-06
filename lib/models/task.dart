enum DueStatus {
  ok,           // mais de 2 dias
  twoDays,      // faltando 2 dias
  oneDay,       // faltando 1 dia
  today,        // vencendo hoje
  overdue       // vencida
}

class Task {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final int quadrant; // 1..4
  final int priority; // mantido para compatibilidade
  final DateTime? dueDate;
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
    this.dueDate,
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
    DateTime? dueDate,
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
      dueDate: dueDate ?? this.dueDate,
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
      'due_date': dueDate?.toIso8601String(),
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
      dueDate: map['due_date'] != null 
          ? DateTime.tryParse(map['due_date'] as String)
          : null,
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Calcula o status de vencimento da tarefa
  DueStatus getDueStatus() {
    if (dueDate == null || isCompleted) return DueStatus.ok;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    final difference = due.difference(today).inDays;
    
    if (difference < 0) return DueStatus.overdue;
    if (difference == 0) return DueStatus.today;
    if (difference == 1) return DueStatus.oneDay;
    if (difference == 2) return DueStatus.twoDays;
    return DueStatus.ok;
  }
}
