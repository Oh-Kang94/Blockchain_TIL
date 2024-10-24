import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3_auction_example/core/extensions/big_int.extensions.dart';
import 'package:web3dart/web3dart.dart';

part 'bid.entity.freezed.dart';

@freezed
class BidEntity with _$BidEntity {
  factory BidEntity({
    required int listingId,
    required EthereumAddress seller,
    required int tokenId,
    required BigInt price,
    required BigInt netPrice,
    required DateTime startAt,
    required DateTime endAt,
    required bool isOpen,
  }) = _BidEntity;

  factory BidEntity.fromRaw(List<dynamic> values) {
    return BidEntity(
      listingId: (values[0] as BigInt).toInt(),
      seller: values[1] as EthereumAddress,
      tokenId: (values[2] as BigInt).toInt(),
      price: values[3] as BigInt,
      netPrice: values[4] as BigInt,
      startAt: (values[5] as BigInt).toDateTime(),
      endAt: (values[6] as BigInt).toDateTime(),
      isOpen: (values[7] as BigInt) == BigInt.zero ? true : false,
    );
  }
}
