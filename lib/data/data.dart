// Data Layer — работа с данными.
// Зависит от Domain. Реализует репозитории и источники данных (Firebase).

// Datasources
export 'datasources/remote/firebase_user_datasource.dart';
export 'datasources/remote/firebase_category_datasource.dart';
export 'datasources/remote/firebase_sub_category_datasource.dart';
export 'datasources/remote/firebase_transaction_datasource.dart';

// Models
export 'models/user_model.dart';
export 'models/transaction_model.dart';
export 'models/category_model.dart';
export 'models/sub_category_model.dart';

// Mappers
export 'mappers/user_mapper.dart';
export 'mappers/transaction_mapper.dart';
export 'mappers/category_mapper.dart';
export 'mappers/sub_category_mapper.dart';

// Repository implementations
export 'repositories/user_repository_impl.dart';
export 'repositories/category_repository_impl.dart';
export 'repositories/sub_category_repository_impl.dart';
export 'repositories/transaction_repository_impl.dart';