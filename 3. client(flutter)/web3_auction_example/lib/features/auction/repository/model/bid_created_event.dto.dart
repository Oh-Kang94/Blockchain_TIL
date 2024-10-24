import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'bid_created_event.dto.freezed.dart';

@freezed
class BidCreatedEventDto with _$BidCreatedEventDto {
  factory BidCreatedEventDto({
    required BigInt listingId,
    required EthereumAddress bidder,
    required BigInt bid,
  }) = _BidCreatedEventDto;
}
