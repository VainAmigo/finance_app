import 'package:finance_app/data/models/transaction_model.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';

/// Преобразование между TransactionModel (Data) и TransactionEntity (Domain).
class TransactionMapper {
  const TransactionMapper();

  TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
      transactionId: model.transactionId,
      amount: model.amount,
      categoryId: model.categoryId,
      createdAt: model.createdAt,
      currency: model.currency,
      date: model.date,
      subCategoryId: model.subCategoryId,
      type: model.type,
    );
  }

  TransactionModel toModel(TransactionEntity entity) {
    return TransactionModel(
      transactionId: entity.transactionId,
      amount: entity.amount,
      categoryId: entity.categoryId,
      createdAt: entity.createdAt,
      currency: entity.currency,
      date: entity.date,
      subCategoryId: entity.subCategoryId,
      type: entity.type,
    );
  }
}
