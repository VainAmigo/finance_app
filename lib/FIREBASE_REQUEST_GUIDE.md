# Полный путь запросов в Firebase

Как делать запросы от бизнес-логики до Firebase. Один файл — вся цепочка.

---

## 1. Схема потока данных

```
┌─────────────────────────────────────────────────────────────────────┐
│  PRESENTATION (UI)                                                   │
│  Widget, Bloc, Provider → вызывает Repository                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  DOMAIN (бизнес-логика)                                              │
│  Entity + Repository (интерфейс) ← здесь работаем с Entity          │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  DATA (реализация)                                                   │
│  RepositoryImpl → Mapper → Model → Datasource → Firebase             │
└─────────────────────────────────────────────────────────────────────┘
```

**Правило:** UI работает только с **Entity** и **Repository**. Никогда не импортирует Model, Datasource или Firebase.

---

## 2. Пошаговый чеклист для новой сущности

Например: категория расходов `Category`.

### Шаг 1: Domain — Entity

**Файл:** `lib/domain/entities/category_entity.dart`

```dart
import 'package:finance_app/domain/entities/entity.dart';

class CategoryEntity extends Entity {
  final String id;
  final String userId;
  final String name;
  final String? iconName;

  const CategoryEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.iconName,
  });
}
```

- Только Dart, без Firebase/Flutter.
- Чистые данные, без `fromFirestore`, `toJson` и т.п.

---

### Шаг 2: Domain — Repository (интерфейс)

**Файл:** `lib/domain/repositories/category_repository.dart`

```dart
import 'package:finance_app/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategoriesByUserId(String userId);
  Future<CategoryEntity?> getCategoryById(String id);
  Future<void> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
  Stream<List<CategoryEntity>> watchCategoriesByUserId(String userId);
}
```

- Описываешь, **что** нужно уметь делать.
- Везде используются **Entity**, не Model.

---

### Шаг 3: Data — Model

**Файл:** `lib/data/models/category_model.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String? iconName;

  const CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    this.iconName,
  });

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return CategoryModel(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      iconName: data['iconName'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'iconName': iconName,
    };
  }
}
```

- `id` берётся из `doc.id`, в `toFirestore()` не кладётся.
- Для `create` можно передавать `id: ''` — Firestore сгенерирует новый.

---

### Шаг 4: Data — Mapper

**Файл:** `lib/data/mappers/category_mapper.dart`

```dart
import 'package:finance_app/data/models/category_model.dart';
import 'package:finance_app/domain/entities/category_entity.dart';

class CategoryMapper {
  const CategoryMapper();

  CategoryEntity toEntity(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      userId: model.userId,
      name: model.name,
      iconName: model.iconName,
    );
  }

  CategoryModel toModel(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      iconName: entity.iconName,
    );
  }
}
```

- `Model → Entity` для чтения.
- `Entity → Model` для записи.

---

### Шаг 5: Data — Datasource

**Файл:** `lib/data/datasources/remote/firebase_category_datasource.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_app/data/models/category_model.dart';

class FirebaseCategoryDatasource {
  FirebaseCategoryDatasource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'categories';

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection(_collection);

  Future<List<CategoryModel>> getByUserId(String userId) async {
    final snapshot = await _ref
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  Future<CategoryModel?> getById(String id) async {
    final doc = await _ref.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return CategoryModel.fromFirestore(doc);
  }

  Future<void> create(CategoryModel model) async {
    final docRef = _ref.doc();
    await docRef.set(model.toFirestore());
  }

  Future<void> update(CategoryModel model) async {
    await _ref.doc(model.id).update(model.toFirestore());
  }

  Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }

  Stream<List<CategoryModel>> watchByUserId(String userId) {
    return _ref
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((d) => CategoryModel.fromFirestore(d)).toList());
  }
}
```

- Только **Model**, без Entity.
- Прямые вызовы Firestore (`get`, `set`, `update`, `delete`, `snapshots`).
- Для запросов с `where` + `orderBy` нужен composite index в Firestore.

---

### Шаг 6: Data — RepositoryImpl

**Файл:** `lib/data/repositories/category_repository_impl.dart`

```dart
import 'package:finance_app/data/datasources/remote/firebase_category_datasource.dart';
import 'package:finance_app/data/mappers/category_mapper.dart';
import 'package:finance_app/domain/entities/category_entity.dart';
import 'package:finance_app/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    FirebaseCategoryDatasource? datasource,
    CategoryMapper? mapper,
  })  : _datasource = datasource ?? FirebaseCategoryDatasource(),
        _mapper = mapper ?? const CategoryMapper();

  final FirebaseCategoryDatasource _datasource;
  final CategoryMapper _mapper;

  @override
  Future<List<CategoryEntity>> getCategoriesByUserId(String userId) async {
    final models = await _datasource.getByUserId(userId);
    return models.map(_mapper.toEntity).toList();
  }

  @override
  Future<CategoryEntity?> getCategoryById(String id) async {
    final model = await _datasource.getById(id);
    return model != null ? _mapper.toEntity(model) : null;
  }

  @override
  Future<void> createCategory(CategoryEntity category) async {
    await _datasource.create(_mapper.toModel(category));
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await _datasource.update(_mapper.toModel(category));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _datasource.delete(id);
  }

  @override
  Stream<List<CategoryEntity>> watchCategoriesByUserId(String userId) {
    return _datasource.watchByUserId(userId).map(
          (models) => models.map(_mapper.toEntity).toList(),
        );
  }
}
```

- Реализует интерфейс из Domain.
- Вызывает Datasource и переводит Model ↔ Entity через Mapper.

---

### Шаг 7: Barrel-файлы

**domain.dart:**
```dart
export 'entities/category_entity.dart';
export 'repositories/category_repository.dart';
```

**data.dart:**
```dart
export 'datasources/remote/firebase_category_datasource.dart';
export 'models/category_model.dart';
export 'mappers/category_mapper.dart';
export 'repositories/category_repository_impl.dart';
```

---

## 3. Использование в UI (Presentation)

```dart
// Provider / GetIt / другой DI
final categoryRepo = CategoryRepositoryImpl();

// Чтение
final categories = await categoryRepo.getCategoriesByUserId(userId);

// Reactive (Stream)
categoryRepo.watchCategoriesByUserId(userId).listen((entities) {
  // обновление UI
});

// Создание
await categoryRepo.createCategory(CategoryEntity(
  id: '',  // Firestore сам сгенерирует
  userId: userId,
  name: 'Еда',
  iconName: 'food',
));

// Обновление
await categoryRepo.updateCategory(existingEntity);

// Удаление
await categoryRepo.deleteCategory(id);
```

---

## 4. Структура коллекций Firestore

```
users/           { id: doc.id }
  { email, displayName, photoUrl, createdAt }

transactions/    { id: doc.id }
  { userId, amount, currencyCode, title, categoryId?, date, isIncome }

categories/      { id: doc.id }
  { userId, name, iconName? }
```

- `id` — всегда `doc.id`.
- Для запросов вида `where('userId', isEqualTo: x).orderBy('date', descending: true)` создай composite index в Firebase Console.

---

## 5. Краткий чеклист

| Шаг | Что | Где |
|-----|-----|-----|
| 1 | Entity | `domain/entities/` |
| 2 | Repository (интерфейс) | `domain/repositories/` |
| 3 | Model + fromFirestore/toFirestore | `data/models/` |
| 4 | Mapper (toEntity/toModel) | `data/mappers/` |
| 5 | Datasource (Firebase) | `data/datasources/remote/` |
| 6 | RepositoryImpl | `data/repositories/` |
| 7 | Экспорты | `domain.dart`, `data.dart` |

---

## 6. Зависимости между слоями

- **Domain** — не зависит ни от чего.
- **Data** — зависит от Domain (Entity, Repository).
- **Presentation** — зависит от Domain (Entity, Repository).

**Нельзя:** импортировать Data (Model, Datasource) в Domain или Presentation.
