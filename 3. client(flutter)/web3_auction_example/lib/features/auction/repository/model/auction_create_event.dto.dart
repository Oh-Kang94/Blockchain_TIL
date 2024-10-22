import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'auction_create_event.dto.freezed.dart';

@freezed
class AuctionCreateEventDto with _$AuctionCreateEventDto {
  factory AuctionCreateEventDto({
    required BigInt listingId,
    required EthereumAddress seller,
    required BigInt price,
    required BigInt tokenId,
    required BigInt startAt,
    required BigInt endAt,
  }) = _AuctionCreateEventDto;

  // factory AuctionCreateEventDto.fromEvent({
  //   required BigInt listingId,
  //   required EthereumAddress seller,
  //   required BigInt price,
  //   required BigInt tokenId,
  //   required BigInt startAt,
  //   required BigInt endAt,
  // }) {
  //   return AuctionCreateEventDto(
  //     listingId: listingId,
  //     seller: seller,
  //     price: price,
  //     tokenId: tokenId,
  //     startAt: startAt,
  //     endAt: endAt,
  //   );
  // }
}
