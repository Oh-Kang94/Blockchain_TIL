// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'wallet.entity.freezed.dart';
part 'wallet.entity.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class WalletEntity with _$WalletEntity {
  const WalletEntity._();

  factory WalletEntity({
    @JsonKey(name: 'private_key') required Id privateKey,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'mnemonic') String? mnemonic,
    @JsonKey(name: 'address') required String address,
    @JsonKey(name: 'amount') required double amount,
    @Default(false) bool isActivate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, dynamic> json) =>
      _$WalletEntityFromJson(json);

  @override
  // ignore: recursive_getters
  Id get privateKey => privateKey;  // Id로 지정된 필드를 반환
}
