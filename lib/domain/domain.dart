// Domain Layer — ядро приложения.
// Не зависит от Data, Presentation или внешних фреймворков.
// Содержит бизнес-сущности и контракты (интерфейсы репозиториев).

export 'entities/entity.dart';
export 'entities/user_entity.dart';
export 'entities/transaction_entity.dart';
export 'entities/category_entity.dart';
export 'entities/sub_category_entity.dart';
export 'entities/category_summary_entity.dart';
export 'entities/sub_category_summary_entity.dart';
export 'repositories/transaction_repository.dart';
export 'repositories/user_repository.dart';
export 'repositories/category_repository.dart';
export 'repositories/sub_category_repository.dart';
export 'usecases/calculate_category_summaries_usecase.dart';
export 'usecases/calculate_sub_category_summaries_usecase.dart';