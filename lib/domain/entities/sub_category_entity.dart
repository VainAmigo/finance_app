import 'package:finance_app/domain/entities/entity.dart';

class SubCategoryEntity extends Entity {
  final String categoryId;
  final DateTime createdAt;
  final String name;
  final String subCategoryId;

  const SubCategoryEntity({
    required this.categoryId,
    required this.createdAt,
    required this.name,
    required this.subCategoryId,
  });
}
