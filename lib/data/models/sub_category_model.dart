import 'package:cloud_firestore/cloud_firestore.dart';

/// DTO модель подкатегории для Firebase Firestore.
class SubCategoryModel {
  final String categoryId;
  final DateTime createdAt;
  final String name;
  final String subCategoryId;

  const SubCategoryModel({
    required this.categoryId,
    required this.createdAt,
    required this.name,
    required this.subCategoryId,
  });

  factory SubCategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return SubCategoryModel(
      categoryId: data['categoryId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      name: data['name'] as String? ?? '',
      subCategoryId: doc.id,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'createdAt': Timestamp.fromDate(createdAt),
      'name': name,
      'subCategoryId': subCategoryId,
    };
  }
}
