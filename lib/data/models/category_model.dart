import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/domain/entities/category_entity.dart';

/// DTO модель категории для Firebase Firestore.
class CategoryModel {
  final String categoryId;
  final String colorId;
  final DateTime createdAt;
  final String currency;
  final bool hasSubCategories;
  final String iconId;
  final LimitType? limitType;
  final double? limitValue;
  final String name;

  const CategoryModel({
    required this.categoryId,
    required this.colorId,
    required this.createdAt,
    required this.currency,
    required this.hasSubCategories,
    required this.iconId,
    required this.name,
    this.limitType,
    this.limitValue,
  });

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return CategoryModel(
      categoryId: doc.id,
      colorId: data['colorId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      currency: data['currency'] as String? ?? 'USD',
      hasSubCategories: data['hasSubCategories'] as bool? ?? false,
      iconId: data['iconId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      limitType: _parseLimitType(data['limitType'] as String?),
      limitValue: (data['limitValue'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'colorId': colorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'currency': currency,
      'hasSubCategories': hasSubCategories,
      'iconId': iconId,
      'limitType': limitType?.name,
      'limitValue': limitValue,
      'name': name,
    };
  }

  static LimitType? _parseLimitType(String? value) {
    switch (value?.toLowerCase()) {
      case 'amount':
        return LimitType.amount;
      case 'percent':
        return LimitType.percent;
      default:
        return null;
    }
  }
}
