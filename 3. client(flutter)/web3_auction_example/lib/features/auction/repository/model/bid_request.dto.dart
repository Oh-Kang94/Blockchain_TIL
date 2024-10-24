import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'bid_request.dto.freezed.dart';

@freezed
class BidRequestDto with _$BidRequestDto {
  factory BidRequestDto({
    required BigInt listingId,
    required EtherAmount amountVale,
  }) = _BidRequestDto;
}
