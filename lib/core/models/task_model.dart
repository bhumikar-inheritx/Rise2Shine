import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { pending, completed }

enum TaskFrequency { daily, weekly, monthly, oneTime }

class TaskModel {
  final String id;
  final String childId;
  final String parentId;
  final String title;
  final String category;
  final int points;
  final TaskFrequency frequency;
  final bool notificationsEnabled;
  final TaskStatus status;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.childId,
    required this.parentId,
    required this.title,
    required this.category,
    required this.points,
    required this.frequency,
    this.notificationsEnabled = true,
    this.status = TaskStatus.pending,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'points': points,
      'frequency': frequency.name,
      'notificationsEnabled': notificationsEnabled,
      'status': status.name,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory TaskModel.fromMap(String id, String childId, String parentId, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      childId: childId,
      parentId: parentId,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      points: map['points'] ?? 0,
      frequency: TaskFrequency.values.firstWhere(
        (e) => e.name == map['frequency'],
        orElse: () => TaskFrequency.daily,
      ),
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create copy with updated fields
  TaskModel copyWith({
    String? title,
    String? category,
    int? points,
    TaskFrequency? frequency,
    bool? notificationsEnabled,
    TaskStatus? status,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id,
      childId: childId,
      parentId: parentId,
      title: title ?? this.title,
      category: category ?? this.category,
      points: points ?? this.points,
      frequency: frequency ?? this.frequency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
