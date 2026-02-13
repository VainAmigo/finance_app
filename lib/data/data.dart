// Data Layer — работа с данными.
// Зависит от Domain. Реализует репозитории и источники данных (Firebase).

// Datasources
export 'datasources/remote/firebase_user_datasource.dart';
export 'datasources/remote/firebase_transaction_datasource.dart';

// Models
export 'models/user_model.dart';
export 'models/transaction_model.dart';

// Mappers
export 'mappers/user_mapper.dart';
export 'mappers/transaction_mapper.dart';

// Repository implementations
export 'repositories/user_repository_impl.dart';
export 'repositories/transaction_repository_impl.dart';
