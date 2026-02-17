import 'package:finance_app/data/datasources/remote/firebase_transaction_datasource.dart';
import 'package:finance_app/data/mappers/transaction_mapper.dart';
import 'package:finance_app/domain/entities/transaction_entity.dart';
import 'package:finance_app/domain/repositories/transaction_repository.dart';

/// Реализация TransactionRepository.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({
    FirebaseTransactionDatasource? datasource,
    TransactionMapper? mapper,
  })  : _datasource = datasource ?? FirebaseTransactionDatasource(),
        _mapper = mapper ?? const TransactionMapper();

  final FirebaseTransactionDatasource _datasource;
  final TransactionMapper _mapper;

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    await _datasource.addTransaction(_mapper.toModel(transaction));
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    await _datasource.updateTransaction(_mapper.toModel(transaction));
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _datasource.deleteTransaction(transactionId);
  }

  @override
  Future<TransactionEntity?> getTransaction(String transactionId) async {
    final model = await _datasource.getTransaction(transactionId);
    return model != null ? _mapper.toEntity(model) : null;
  }

  @override
  Future<List<TransactionEntity>> getTransactions([
    TransactionFilter? filter,
  ]) async {
    final models = await _datasource.getTransactions(
      from: filter?.from,
      to: filter?.to,
      categoryId: filter?.categoryId,
      type: filter?.type,
    );
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getAllTransactionsForSummary([
    TransactionFilter? filter,
  ]) async {
    final models = await _datasource.getAllTransactions(
      from: filter?.from,
      to: filter?.to,
      type: filter?.type,
    );
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions([
    TransactionFilter? filter,
  ]) {
    return _datasource.watchTransactions(
      from: filter?.from,
      to: filter?.to,
      categoryId: filter?.categoryId,
      type: filter?.type,
    ).map((models) => models.map(_mapper.toEntity).toList());
  }
}
