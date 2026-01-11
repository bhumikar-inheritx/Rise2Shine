import 'package:cloud_firestore/cloud_firestore.dart';

class RewardModel {
  final String id;
  final String childId;
  final String parentId;
  final String name;
  final String description;
  final int requiredPoints;
  final String category;
  final bool isRedeemed;
  final DateTime? redeemedAt;
  final DateTime createdAt;

  RewardModel({
    required this.id,
    required this.childId,
    required this.parentId,
    required this.name,
    required this.description,
    required this.requiredPoints,
    required this.category,
    this.isRedeemed = false,
    this.redeemedAt,
    required this.createdAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'requiredPoints': requiredPoints,
      'category': category,
      'isRedeemed': isRedeemed,
      'redeemedAt': redeemedAt != null ? Timestamp.fromDate(redeemedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory RewardModel.fromMap(String id, String childId, String parentId, Map<String, dynamic> map) {
    return RewardModel(
      id: id,
      childId: childId,
      parentId: parentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      requiredPoints: map['requiredPoints'] ?? 0,
      category: map['category'] ?? '',
      isRedeemed: map['isRedeemed'] ?? false,
      redeemedAt: (map['redeemedAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create copy with updated fields
  RewardModel copyWith({
    String? name,
    String? description,
    int? requiredPoints,
    String? category,
    bool? isRedeemed,
    DateTime? redeemedAt,
  }) {
    return RewardModel(
      id: id,
      childId: childId,
      parentId: parentId,
      name: name ?? this.name,
      description: description ?? this.description,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      category: category ?? this.category,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      createdAt: createdAt,
    );
  }
}
