import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'wallet.entity.freezed.dart';
part 'wallet.entity.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class WalletEntity with _$WalletEntity {
  const WalletEntity._();
  factory WalletEntity({
    @JsonKey(name: 'wallet_idx') @Default(Isar.autoIncrement) int walletIdx,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'private_key') required String privateKey,
    @JsonKey(name: 'address') required String address,
    @Default(false) bool isActivate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _WalletEntity;

  factory WalletEntity.fromJson(Map<String, dynamic> json) =>
      _$WalletEntityFromJson(json);

  @override
  // ignore: recursive_getters
  Id get walletIdx => walletIdx;
}
