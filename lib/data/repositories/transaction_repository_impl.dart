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
  Future<List<TransactionEntity>> getTransactionsByUserId(String userId) async {
    final models = await _datasource.getByUserId(userId);
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    final model = await _datasource.getById(id);
    return model != null ? _mapper.toEntity(model) : null;
  }

  @override
  Future<void> createTransaction(TransactionEntity transaction) async {
    await _datasource.create(_mapper.toModel(transaction));
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    await _datasource.update(_mapper.toModel(transaction));
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _datasource.delete(id);
  }

  @override
  Stream<List<TransactionEntity>> watchTransactionsByUserId(String userId) {
    return _datasource.watchByUserId(userId).map(
          (models) => models.map(_mapper.toEntity).toList(),
        );
  }
}
