import 'package:finance_app/data/models/user_model.dart';
import 'package:finance_app/domain/entities/user_entity.dart';

/// Преобразование между UserModel (Data) и UserEntity (Domain).
/// Domain слой не знает о моделях — Data слой обеспечивает маппинг.
class UserMapper {
  const UserMapper();

  UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
      createdAt: model.createdAt,
    );
  }

  UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
    );
  }
}
