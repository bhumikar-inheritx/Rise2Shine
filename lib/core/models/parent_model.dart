import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModel {
  final String id; // Firebase UID
  final String fullName;
  final String phoneNumber;
  final bool isPasscodeSet;
  final DateTime createdAt;
  final DateTime updatedAt;

  ParentModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.isPasscodeSet,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'isPasscodeSet': isPasscodeSet,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory ParentModel.fromMap(String id, Map<String, dynamic> map) {
    return ParentModel(
      id: id,
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      isPasscodeSet: map['isPasscodeSet'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create copy with updated fields
  ParentModel copyWith({
    String? fullName,
    String? phoneNumber,
    bool? isPasscodeSet,
    DateTime? updatedAt,
  }) {
    return ParentModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPasscodeSet: isPasscodeSet ?? this.isPasscodeSet,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
