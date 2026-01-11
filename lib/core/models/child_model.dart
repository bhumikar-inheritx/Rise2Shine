import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  final String id;
  final String parentId;
  final String name;
  final DateTime dob;
  final String? avatarUrl;
  final String? passcodeHash;
  final int totalPoints;
  final DateTime createdAt;

  ChildModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.dob,
    this.avatarUrl,
    this.passcodeHash,
    this.totalPoints = 0,
    required this.createdAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': Timestamp.fromDate(dob),
      'avatarUrl': avatarUrl,
      'passcodeHash': passcodeHash,
      'totalPoints': totalPoints,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory ChildModel.fromMap(String id, String parentId, Map<String, dynamic> map) {
    return ChildModel(
      id: id,
      parentId: parentId,
      name: map['name'] ?? '',
      dob: (map['dob'] as Timestamp?)?.toDate() ?? DateTime.now(),
      avatarUrl: map['avatarUrl'],
      passcodeHash: map['passcodeHash'],
      totalPoints: map['totalPoints'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create copy with updated fields
  ChildModel copyWith({
    String? name,
    DateTime? dob,
    String? avatarUrl,
    String? passcodeHash,
    int? totalPoints,
  }) {
    return ChildModel(
      id: id,
      parentId: parentId,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      passcodeHash: passcodeHash ?? this.passcodeHash,
      totalPoints: totalPoints ?? this.totalPoints,
      createdAt: createdAt,
    );
  }
}
