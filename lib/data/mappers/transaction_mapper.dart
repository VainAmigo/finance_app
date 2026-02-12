import 'package:finance_app/data/models/transaction_model.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';

class TransactionMapper {
  const TransactionMapper();

  TransactionEntity toEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      userId: model.userId,
      amount: model.amount,
      currencyCode: model.currencyCode,
      title: model.title,
      categoryId: model.categoryId,
      date: model.date,
      isIncome: model.isIncome,
    );
  }

  TransactionModel toModel(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      userId: entity.userId,
      amount: entity.amount,
      currencyCode: entity.currencyCode,
      title: entity.title,
      categoryId: entity.categoryId,
      date: entity.date,
      isIncome: entity.isIncome,
    );
  }
}
