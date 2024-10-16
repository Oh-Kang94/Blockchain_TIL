import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft.entity.freezed.dart';
part 'nft.entity.g.dart';

@freezed
class NftEntity with _$NftEntity {
  factory NftEntity({
    required String name,
    required int tokenId,
    required String price,
    required String imageUrl,
    required bool isAuction,
    required String owner,
  }) = _NftEntity;

  factory NftEntity.fromJson(Map<String, dynamic> json) =>
      _$NftEntityFromJson(json);
}
