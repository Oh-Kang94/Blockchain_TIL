import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';

part 'nft.model.freezed.dart';
part 'nft.model.g.dart';

@freezed
class Nft with _$Nft {
  factory Nft({
    required String name,
    required int tokenId,
    required String tokenURI,
    required bool isAuction,
    required BigInt price,
    required String owner,
  }) = _Nft;

  factory Nft.fromJson(Map<String, dynamic> json) => _$NftFromJson(json);
}

extension NftX on Nft {
  NftEntity toEntity() {
    return NftEntity(
      name: name,
      tokenId: tokenId,
      price: price.toStringInEther,
      imageUrl: tokenURI,
      isAuction: isAuction,
      owner: owner,
    );
  }
}
